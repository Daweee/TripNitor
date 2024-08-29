from rest_framework import serializers
from ..models.driver_booking_model import DriverBooking
from .driver_serializer import DriverSerializer

class DriverBookingSerializer(serializers.ModelSerializer):
    driver = DriverSerializer(read_only=True)

    class Meta:
        model = DriverBooking
        fields = ['driver', 'passengers']