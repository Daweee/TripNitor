from rest_framework import serializers
from ..models import Location

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ['id', 'name', 'latitude', 'longitude']

class LocationQuerySerializer(serializers.Serializer):
    lat = serializers.FloatField(min_value=-90, max_value=90)
    lng = serializers.FloatField(min_value=-180, max_value=180)
    region = serializers.CharField(required=False, allow_null=True, allow_blank=True)

    def validate_region(self, value):
        """
        Case-insensitive validation for region field.
        Converts any valid input to uppercase.
        """
        if not value:
            return None
            
        value = str(value).strip().upper()
        valid_regions = ['NORTH', 'SOUTH', 'CITY']
        
        if value in valid_regions:
            return value
        
        raise serializers.ValidationError(
            f"Region must be one of: {', '.join(valid_regions)} (case insensitive)"
        )

    def to_internal_value(self, data):
        """
        Override to ensure we handle region case before any validation occurs.
        """
        if 'region' in data and data['region']:
            data = data.copy()
            data['region'] = str(data['region']).strip().upper()
        return super().to_internal_value(data)