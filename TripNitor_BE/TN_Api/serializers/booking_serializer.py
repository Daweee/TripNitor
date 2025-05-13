from decimal import Decimal
from django.conf import settings
from django.forms import ValidationError
from rest_framework import serializers
from ..models import Booking, Package, User, Driver, BookingLeg  
from .package_serializer import PackageSerializer, PackageBasicSerializer
from .user_serializer import UserSerializer
from .driver_serializer import DriverSerializer
from .booking_leg_serializer import BookingLegSerializer
from .location_serializer import LocationSerializer
from dateutil.parser import parse
from django.utils.timezone import is_aware, make_aware
from pytz import timezone
from django.db import transaction

class BookingSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    package = PackageBasicSerializer(read_only=True)
    drivers = DriverSerializer(many=True, read_only=True)
    booking_legs = BookingLegSerializer(many=True, read_only=True)
    start_location = LocationSerializer(read_only=True)
    final_destination = LocationSerializer(read_only=True)  

    class Meta:
        model = Booking
        fields = '__all__'
        read_only_fields = ('status', 'total_price')

class BookingCreationSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    package = serializers.PrimaryKeyRelatedField(queryset=Package.objects.all())
    drivers = serializers.PrimaryKeyRelatedField(queryset=Driver.objects.all(), many=True, write_only=True)
    updated_package_fare = serializers.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        model = Booking
        fields = '__all__' 
        read_only_fields = ('status', 'base_fare', 'number_of_nights', 'ratings', 'is_rated')

    def validate(self, data):
        from ..services import BookingService
        
        BookingService.validate_booking_dates(data['start_date'], data['end_date'])
        
        temp_booking = Booking(
            package=data['package'],
            start_date=data['start_date'],
            end_date=data['end_date'],
            number_of_passengers=data['number_of_passengers']
        )
        
        BookingService.validate_capacity(temp_booking)

        user_id = data['user'].id
        has_conflicts, error_message = BookingService.check_user_booking_conflicts(
            user_id=user_id,
            start_date=data['start_date'],
            end_date=data['end_date']
        )

        if has_conflicts:
            raise serializers.ValidationError(error_message)
        
        return data

    def create(self, validated_data):
        from ..models import DriverAssignment, BookingLeg
        from ..services import BookingService, PackageService
        
        drivers_data = validated_data.pop('drivers', [])
        package = validated_data.get('package')
        user = validated_data.get('user')

        if package and package.visibility == Package.PackageVisibility.JOINER:
            number_of_passengers = validated_data.get('number_of_passengers', 1)
            
            validated_data['start_date'] = package.start_date
            validated_data['end_date'] = package.end_date

            has_conflicts, error_message = BookingService.check_user_booking_conflicts(
                user_id=user.id,
                start_date=package.start_date,
                end_date=package.end_date
            )
            
            if has_conflicts:
                raise serializers.ValidationError(error_message)

            validated_data['number_of_nights'] = BookingService.get_nights(
                package.start_date, package.end_date
            )
            validated_data['base_fare'] = Decimal('3000')
            
            if package.assigned_driver:
                drivers_data = [package.assigned_driver]
        else:
            validated_data['number_of_nights'] = BookingService.get_nights(
                validated_data['start_date'], 
                validated_data['end_date']
            )
            validated_data['base_fare'] = Decimal('3000')
        
        with transaction.atomic():
            booking = super().create(validated_data)
            
            BookingService.set_booking_locations(booking)
            booking.save(update_fields=['start_location', 'final_destination'])
            
            if package and package.visibility == Package.PackageVisibility.JOINER:
                package_user = PackageService.join_package(
                    package_id=package.id,
                    user_id=user.id,
                    number_of_passengers=number_of_passengers,
                    booking=booking 
                )
            
            for driver in drivers_data:
                DriverAssignment.objects.create(booking=booking, driver=driver, user=user)
            
            BookingService.calculate_final_fare(booking, booking.drivers.all())
            booking.save(update_fields=['total_price', 'updated_package_fare'])

            if package:
                for leg in package.legs.all().order_by('leg_number'):
                    BookingLeg.objects.create(
                        booking=booking,
                        leg_number=leg.leg_number,
                        start_location=leg.start_location,
                        end_location=leg.end_location,
                        departure_time=None,
                        arrival_time=None,
                        original_leg_id=leg.id
                    )
                    
            return booking
    
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['user'] = UserSerializer(instance.user).data
        representation['package'] = PackageSerializer(instance.package).data
        representation['drivers'] = DriverSerializer(instance.drivers.all(), many=True).data
        representation['start_location'] = LocationSerializer(instance.start_location).data if instance.start_location else None
        representation['final_destination'] = LocationSerializer(instance.final_destination).data if instance.final_destination else None
        return representation
    
class BookingPreviewSerializer(serializers.ModelSerializer):
    package = serializers.CharField() 
    start_date = serializers.DateTimeField()
    end_date = serializers.DateTimeField()
    number_of_passengers = serializers.IntegerField(min_value=1)
    base_fare = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    number_of_nights = serializers.IntegerField(read_only=True)
    assigned_driver = serializers.PrimaryKeyRelatedField(
        queryset=Driver.objects.all(),
        required=False,
        allow_null=True
    )

    class Meta:
        model = Booking
        fields = ['package', 'start_date', 'end_date', 'number_of_passengers', 
                  'base_fare', 'number_of_nights', 'assigned_driver']
        read_only_fields = ['base_fare', 'number_of_nights']

    def validate_package(self, value):
        try:
            return Package.objects.get(id=value)
        except Package.DoesNotExist:
            raise serializers.ValidationError(f"Package with ID {value} does not exist.")

    def validate(self, data):
        if data['start_date'] >= data['end_date']:
            raise serializers.ValidationError("End date must be after start date.")
        
        user = None
        if self.context and 'request' in self.context and hasattr(self.context['request'], 'user'):
            user = self.context['request'].user

        if user and user.is_authenticated:
            from ..services import BookingService
            
            has_conflicts, error_message = BookingService.check_user_booking_conflicts(
                user_id=user.id,
                start_date=data['start_date'],
                end_date=data['end_date']
            )
            
            if has_conflicts:
                raise serializers.ValidationError(error_message)

        package = data['package']
        number_of_passengers = data['number_of_passengers']
        
        if package.visibility == 'JOINER':
            max_participants = package.max_participants or 15
            
            current_participants = package.current_participants or 0
            
            total_participants = current_participants + number_of_passengers
            
            if total_participants > max_participants:
                remaining_slots = max_participants - current_participants
                if remaining_slots <= 0:
                    raise serializers.ValidationError(
                        f"This joiner package is already full. Maximum capacity is {max_participants}."
                    )
                else:
                    raise serializers.ValidationError(
                        f"Cannot add {number_of_passengers} passengers. Only {remaining_slots} slots remaining. " 
                        f"Maximum capacity for joiner packages is {max_participants}."
                    )
        
        return data

    def to_internal_value(self, data):
        for field in ['start_date', 'end_date']:
            if isinstance(data.get(field), str):
                try:
                    parsed_date = parse(data[field])
                    if not is_aware(parsed_date):
                        tz = timezone(settings.TIME_ZONE)
                        parsed_date = make_aware(parsed_date, tz)
                    data[field] = parsed_date
                except ValueError as e:
                    raise serializers.ValidationError({field: f"Invalid date format: {str(e)}"})
        return super().to_internal_value(data)
    
class BookingStatusUpdateSerializer(serializers.Serializer):
    id = serializers.CharField(read_only=True)
    status = serializers.CharField(read_only=True)

class ConfirmJoinerPackageBookingsSerializer(serializers.Serializer):
    package_id = serializers.CharField(required=True, help_text="ID of the package to confirm all pending bookings for")

    def validate_package_id(self, value):
        try:
            package = Package.objects.get(id=value)
            return value
        except Package.DoesNotExist:
            raise serializers.ValidationError(f"Package with ID {value} does not exist.")