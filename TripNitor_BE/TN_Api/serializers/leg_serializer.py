from rest_framework import serializers
from ..models import Leg, Location
from .location_serializer import LocationSerializer

class LegSerializer(serializers.ModelSerializer):
    start_location = LocationSerializer()
    end_location = LocationSerializer()

    class Meta:
        model = Leg
        fields = ['id', 'leg_number', 'start_location', 'end_location', 'departure_time', 'arrival_time']