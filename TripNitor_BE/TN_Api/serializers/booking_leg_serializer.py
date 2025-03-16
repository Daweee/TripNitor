from rest_framework import serializers
from .location_serializer import LocationSerializer
from ..models import BookingLeg

class BookingLegSerializer(serializers.ModelSerializer):
    start_location = LocationSerializer()
    end_location = LocationSerializer()

    class Meta:
        model = BookingLeg
        fields = ['id', 'leg_number', 'start_location', 'end_location', 'departure_time', 'arrival_time']