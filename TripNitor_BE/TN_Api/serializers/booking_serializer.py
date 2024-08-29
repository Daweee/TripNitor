from rest_framework import serializers
from ..models import Booking
from .driver_booking_serializer import DriverBookingSerializer
from .package_serializer import PackageSerializer

class BookingSerializer(serializers.ModelSerializer):
    driver_bookings = DriverBookingSerializer(many=True, read_only=True)
    package = PackageSerializer(read_only=True)
    mode_of_payment = serializers.ChoiceField(choices=Booking.PaymentMode.choices)

    class Meta:
        model = Booking
        fields = ['id', 'user', 'package', 'start_date', 'end_date', 'status', 
                  'total_price', 'number_of_passengers', 'mode_of_payment', 'driver_bookings']

    def create(self, validated_data):
        booking = Booking.objects.create(**validated_data)
        return booking