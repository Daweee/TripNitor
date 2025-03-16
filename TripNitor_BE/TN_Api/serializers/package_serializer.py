from rest_framework import serializers
from ..models import Package, Leg, Location
from .leg_serializer import LegSerializer
from .location_serializer import LocationSerializer
from ..services import PackageService
from decimal import Decimal


class PackageSerializer(serializers.ModelSerializer):
    legs = LegSerializer(many=True, required=False)
    start_location = LocationSerializer(required=False)
    final_destination = LocationSerializer(required=False)
    total_distance = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)
    base_price = serializers.DecimalField(max_digits=10, decimal_places=2, required=False)

    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'package_type', 'visibility', 
                  'start_location', 'final_destination', 'legs', 'max_participants', 
                  'current_participants', 'start_date', 'end_date', 'total_distance']

    def create(self, validated_data):
        return PackageService.create_package(validated_data)
    
    def update(self, instance, validated_data):
        return PackageService.update_package(instance, validated_data)

class FareCalculationSerializer(serializers.Serializer):
    total_distance = serializers.DecimalField(max_digits=10, decimal_places=2)

class PackageBasicSerializer(serializers.ModelSerializer):
    start_location = LocationSerializer(required=False)
    final_destination = LocationSerializer(required=False)
    
    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'package_type', 'visibility', 
                  'start_location', 'final_destination', 'max_participants', 
                  'current_participants', 'start_date', 'end_date', 'total_distance']