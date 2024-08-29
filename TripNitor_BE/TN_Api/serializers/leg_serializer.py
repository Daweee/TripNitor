from rest_framework import serializers
from ..models import Leg, Location
from .location_serializer import LocationSerializer

class LegSerializer(serializers.ModelSerializer):
    start_location = LocationSerializer()
    end_location = LocationSerializer()

    class Meta:
        model = Leg
        fields = ['id', 'leg_number', 'start_location', 'end_location', 'departure_time', 'arrival_time']

    def create(self, validated_data):
        start_location_data = validated_data.pop('start_location')
        end_location_data = validated_data.pop('end_location')
        start_location, _ = Location.objects.get_or_create(**start_location_data)
        end_location, _ = Location.objects.get_or_create(**end_location_data)
        return Leg.objects.create(start_location=start_location, end_location=end_location, **validated_data)