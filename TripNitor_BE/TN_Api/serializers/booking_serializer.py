from rest_framework import serializers
from TN_Api.models import Booking

class BookingSerializer(serializers.ModelSerializer):

    class Meta:
        model = Booking
        fields = '__all__'