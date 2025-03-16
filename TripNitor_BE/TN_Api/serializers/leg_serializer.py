from rest_framework import serializers
from ..models import Leg, Location
from .location_serializer import LocationSerializer

class LegSerializer(serializers.ModelSerializer):
    start_location = LocationSerializer()
    end_location = LocationSerializer()

    class Meta:
        model = Leg
        fields = ['id', 'leg_number', 'start_location', 'end_location']
    
    def to_internal_value(self, data):
        """Preserve the ID during deserialization"""
        if 'id' in data:
            # Ensure we preserve the ID field
            internal_value = super().to_internal_value(data)
            internal_value['id'] = data['id']
            return internal_value
        return super().to_internal_value(data)