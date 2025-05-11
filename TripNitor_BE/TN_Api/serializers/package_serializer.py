from rest_framework import serializers
from ..models import Package, Leg, Location, User
from .leg_serializer import LegSerializer
from .location_serializer import LocationSerializer
from .driver_serializer import DriverSerializer
from .user_serializer import UserSerializer
from ..services import PackageService
from decimal import Decimal


class PackageSerializer(serializers.ModelSerializer):
    legs = LegSerializer(many=True, required=False)
    start_location = LocationSerializer(required=False)
    final_destination = LocationSerializer(required=False)
    assigned_driver = DriverSerializer(required=False)
    total_distance = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)
    base_price = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)
    created_by = UserSerializer(read_only=True)

    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'package_type', 'visibility', 
                  'start_location', 'final_destination', 'legs', 'max_participants', 
                  'current_participants', 'assigned_driver', 'start_date', 'end_date', 'total_distance',
                  'is_confirmed', 'is_completed', 'created_by']

    def create(self, validated_data):
        if 'visibility' in validated_data and validated_data['visibility'] == Package.PackageVisibility.JOINER:
            return PackageService.create_joiner_package(validated_data)

        return PackageService.create_package(validated_data)
    
    def update(self, instance, validated_data):
        return PackageService.update_package(instance, validated_data)

class FareCalculationSerializer(serializers.Serializer):
    total_distance = serializers.DecimalField(max_digits=10, decimal_places=2)

class PackageBasicSerializer(serializers.ModelSerializer):
    start_location = LocationSerializer(required=False)
    final_destination = LocationSerializer(required=False)
    assigned_driver = DriverSerializer(required=False)
    created_by = UserSerializer(read_only=True)
    
    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'package_type', 'visibility', 
                  'start_location', 'final_destination', 'max_participants', 
                  'current_participants', 'assigned_driver', 'start_date', 'end_date', 'total_distance',
                  'is_confirmed', 'is_completed', 'created_by']

class JoinPackageSerializer(serializers.Serializer):
    user_id = serializers.CharField()
    number_of_passengers = serializers.IntegerField(min_value=1)
    
    def validate_user_id(self, value):
        try:
            User.objects.get(id=value)
            return value
        except User.DoesNotExist:
            raise serializers.ValidationError(f"User with ID {value} does not exist")
        
class PackageMinimalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Package
        fields = ['id', 'package_name']