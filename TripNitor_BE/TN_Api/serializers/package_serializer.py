from rest_framework import serializers
from ..models import Package, Leg, Location
from .leg_serializer import LegSerializer
from .location_serializer import LocationSerializer


class PackageSerializer(serializers.ModelSerializer):
    legs = LegSerializer(many=True, required=False)
    start_location = LocationSerializer(required=False)
    final_destination = LocationSerializer(required=False)

    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'package_type', 'visibility', 
                  'start_location', 'final_destination', 'legs', 'max_participants', 
                  'current_participants', 'start_date', 'end_date']

    def validate(self, data):
        if data['visibility'] == Package.PackageVisibility.JOINER and not data.get('max_participants'):
            raise serializers.ValidationError("Max participants is required for joiner packages.")
        return data
    
    def create(self, validated_data):
        legs_data = validated_data.pop('legs', [])
        start_location_data = validated_data.pop('start_location', None)
        final_destination_data = validated_data.pop('final_destination', None)

        if start_location_data:
            start_location, _ = Location.objects.get_or_create(**start_location_data)
            validated_data['start_location'] = start_location

        if final_destination_data:
            final_destination, _ = Location.objects.get_or_create(**final_destination_data)
            validated_data['final_destination'] = final_destination

        package = Package.objects.create(**validated_data)

        for leg_data in legs_data:
            start_location_data = leg_data.pop('start_location')
            end_location_data = leg_data.pop('end_location')
            start_location, _ = Location.objects.get_or_create(**start_location_data)
            end_location, _ = Location.objects.get_or_create(**end_location_data)
            Leg.objects.create(package=package, start_location=start_location, end_location=end_location, **leg_data)

        return package

    def update(self, instance, validated_data):
        legs_data = validated_data.pop('legs', [])
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