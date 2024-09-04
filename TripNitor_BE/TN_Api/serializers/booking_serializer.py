from django.forms import ValidationError
from rest_framework import serializers
from ..models import Booking, Package, User   
from .package_serializer import PackageSerializer
from .user_serializer import UserSerializer
from .driver_serializer import DriverSerializer

class BookingSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    package = PackageSerializer(read_only=True)
    drivers = DriverSerializer(many=True, read_only=True)

    class Meta:
        model = Booking
        fields = '__all__'
        read_only_fields = ('status', 'total_price')

class BookingCreationSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    package = serializers.PrimaryKeyRelatedField(queryset=Package.objects.all())
    drivers = DriverSerializer(many=True, read_only=True)

    class Meta:
        model = Booking
        fields = '__all__'
        read_only_fields = ('status', 'total_price')

    def validate(self, data):
        package = data['package']
        return data

    def create(self, validated_data):
        booking = super().create(validated_data)
        return booking
    
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['drivers'] = DriverSerializer(instance.drivers.all(), many=True).data
        return representation