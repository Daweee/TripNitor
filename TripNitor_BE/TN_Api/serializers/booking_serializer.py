from django.conf import settings
from django.forms import ValidationError
from rest_framework import serializers
from ..models import Booking, Package, User, Driver  
from .package_serializer import PackageSerializer
from .user_serializer import UserSerializer
from .driver_serializer import DriverSerializer
from dateutil.parser import parse
from django.utils.timezone import is_aware, make_aware
from pytz import timezone

class BookingSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    package = PackageSerializer(read_only=True)
    drivers = DriverSerializer(many=True, read_only=True)

    class Meta:
        model = Booking
        fields = '__all__'
        read_only_fields = ('status', 'total_price')

class BookingCreationSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    package = serializers.PrimaryKeyRelatedField(queryset=Package.objects.all())
    drivers = serializers.PrimaryKeyRelatedField(queryset=Driver.objects.all(), many=True, write_only=True)  # Accept driver IDs
    updated_package_fare = serializers.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        model = Booking
        fields = '__all__'
        read_only_fields = ('status', 'base_fare', 'number_of_nights')

    def validate(self, data):
        package = data['package']
        return data

    def create(self, validated_data):
        from ..models import DriverAssignment
        drivers_data = validated_data.pop('drivers', [])
        booking = super().create(validated_data)

        for driver in drivers_data:
            DriverAssignment.objects.create(booking=booking, driver=driver)

        return booking
    
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['user'] = UserSerializer(instance.user).data
        representation['package'] = PackageSerializer(instance.package).data
        representation['drivers'] = DriverSerializer(instance.drivers.all(), many=True).data
        return representation
    
class BookingPreviewSerializer(serializers.ModelSerializer):
    package = serializers.CharField() 
    start_date = serializers.DateTimeField()
    end_date = serializers.DateTimeField()
    number_of_passengers = serializers.IntegerField(min_value=1)
    base_fare = serializers.DecimalField(max_digits=10, decimal_places=2, read_only=True)
    number_of_nights = serializers.IntegerField(read_only=True)

    class Meta:
        model = Booking
        fields = ['package', 'start_date', 'end_date', 'number_of_passengers', 'base_fare', 'number_of_nights']
        read_only_fields = ['base_fare', 'number_of_nights']

    def validate_package(self, value):
        try:
            return Package.objects.get(id=value)
        except Package.DoesNotExist:
            raise serializers.ValidationError(f"Package with ID {value} does not exist.")

    def validate(self, data):
        if data['start_date'] >= data['end_date']:
            raise serializers.ValidationError("End date must be after start date.")
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