from rest_framework import serializers
from ..serializers import BookingSerializer, DriverSerializer
from ..models import DriverAssignment, Booking, Driver

class DriverAssignmentSerializer(serializers.ModelSerializer):
    booking = BookingSerializer()
    driver = DriverSerializer()

    class Meta:
        model = DriverAssignment
        fields = '__all__'

    def create(self, validated_data):
        booking_data = validated_data.pop('booking')
        driver_data = validated_data.pop('driver')
        
        booking = Booking.objects.get(pk=booking_data['id'])  
        driver = Driver.objects.get(pk=driver_data['id']) 

        validated_data['start_date'] = booking.start_date
        validated_data['end_date'] = booking.end_date
        
        driver_assignment = DriverAssignment.objects.create(driver=driver, booking=booking, **validated_data)
        return driver_assignment