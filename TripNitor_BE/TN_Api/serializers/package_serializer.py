from rest_framework import serializers
from ..models import Package, Leg, Location
from .leg_serializer import LegSerializer
from .location_serializer import LocationSerializer
from decimal import Decimal


class PackageSerializer(serializers.ModelSerializer):
    legs = LegSerializer(many=True, required=False)
    start_location = LocationSerializer(required=False)
    final_destination = LocationSerializer(required=False)
    total_distance = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)
    base_price = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)

    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'package_type', 'visibility', 
                  'start_location', 'final_destination', 'legs', 'max_participants', 
                  'current_participants', 'start_date', 'end_date', 'total_distance']

    def validate(self, data):
        if data['visibility'] == Package.PackageVisibility.JOINER and not data.get('max_participants'):
            raise serializers.ValidationError("Max participants is required for joiner packages.")
        return data
    
    def create(self, validated_data):
        # Example with precision normalization
        def normalize_decimal(value):
            return Decimal(value).quantize(Decimal('0.000001'))

        legs_data = validated_data.pop('legs', [])
        start_location_data = validated_data.pop('start_location', None)
        final_destination_data = validated_data.pop('final_destination', None)

        if start_location_data:
            start_location, _ = Location.objects.get_or_create(
                name=start_location_data['name'].strip(),
                latitude=normalize_decimal(start_location_data['latitude']),
                longitude=normalize_decimal(start_location_data['longitude'])
            )
            validated_data['start_location'] = start_location

        if final_destination_data:
            final_destination, _ = Location.objects.get_or_create(
                name=final_destination_data['name'].strip(),
                latitude=normalize_decimal(final_destination_data['latitude']),
                longitude=normalize_decimal(final_destination_data['longitude'])
            )
            validated_data['final_destination'] = final_destination

        package = Package.objects.create(**validated_data)

        # If base_price is not provided, calculate it
        if 'base_price' not in validated_data:
            package.base_price = package.calculate_base_price()

        package.save()

        for leg_data in legs_data:
            start_location_data = leg_data.pop('start_location')
            end_location_data = leg_data.pop('end_location')
            start_location, _ = Location.objects.get_or_create(
                name=start_location_data['name'].strip(),
                latitude=normalize_decimal(start_location_data['latitude']),
                longitude=normalize_decimal(start_location_data['longitude'])
            )
            end_location, _ = Location.objects.get_or_create(
                name=end_location_data['name'].strip(),
                latitude=normalize_decimal(end_location_data['latitude']),
                longitude=normalize_decimal(end_location_data['longitude'])
            )
            Leg.objects.create(package=package, start_location=start_location, end_location=end_location, **leg_data)

        return package

    def update(self, instance, validated_data):
        legs_data = validated_data.pop('legs', [])

        # Handle base_price update
        if 'base_price' not in validated_data and 'total_distance' in validated_data:
            instance.total_distance = validated_data['total_distance']
            validated_data['base_price'] = instance.calculate_base_price()

        instance = super().update(instance, validated_data)

        instance = super().update(instance, validated_data)
        
        # Update or create legs
        for leg_data in legs_data:
            leg_id = leg_data.get('id')
            if leg_id:
                leg = Leg.objects.get(id=leg_id, package=instance)
                for key, value in leg_data.items():
                    setattr(leg, key, value)
                leg.save()
            else:
                start_location_data = leg_data.pop('start_location')
                end_location_data = leg_data.pop('end_location')
                start_location, _ = Location.objects.get_or_create(**start_location_data)
                end_location, _ = Location.objects.get_or_create(**end_location_data)
                Leg.objects.create(package=instance, start_location=start_location, end_location=end_location, **leg_data)
        
        start_location_data = validated_data.pop('start_location', None)
        final_destination_data = validated_data.pop('final_destination', None)

        if start_location_data:
            start_location, _ = Location.objects.get_or_create(**start_location_data)
            instance.start_location = start_location

        if final_destination_data:
            final_destination, _ = Location.objects.get_or_create(**final_destination_data)
            instance.final_destination = final_destination

        instance.save()

        return instance
    
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['legs'] = LegSerializer(instance.legs.all(), many=True).data
        return representation