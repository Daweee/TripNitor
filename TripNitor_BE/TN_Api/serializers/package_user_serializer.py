from rest_framework import serializers
from ..models import PackageUser
from ..serializers import UserSerializer, PackageSerializer, BookingSerializer

class PackageUserSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    package = PackageSerializer(read_only=True)
    booking = BookingSerializer(read_only=True)

    class Meta:
        model = PackageUser
        fields = ['id', 'user', 'package', 'number_of_passengers', 'joined_at', 'booking']