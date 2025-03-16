from rest_framework import serializers
from ..models import Location
from decimal import Decimal, ROUND_DOWN, InvalidOperation

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ['id', 'name', 'address', 'latitude', 'longitude']

    def to_internal_value(self, data):
        """Normalize decimal values before validation"""
        if isinstance(data, dict):
            data = data.copy()
            
            if 'latitude' in data:
                try:
                    data['latitude'] = str(Decimal(str(data['latitude'])).quantize(
                        Decimal('0.000001'),
                        rounding=ROUND_DOWN
                    ))
                except (TypeError, ValueError, InvalidOperation):
                    pass  

            if 'longitude' in data:
                try:
                    data['longitude'] = str(Decimal(str(data['longitude'])).quantize(
                        Decimal('0.000001'),
                        rounding=ROUND_DOWN
                    ))
                except (TypeError, ValueError, InvalidOperation):
                    pass 

        return super().to_internal_value(data)

    def validate_latitude(self, value):
        """Additional validation for latitude"""
        try:
            decimal_val = Decimal(str(value))
            if decimal_val < -90 or decimal_val > 90:
                raise serializers.ValidationError("Latitude must be between -90 and 90")
            return decimal_val.quantize(Decimal('0.000001'), rounding=ROUND_DOWN)
        except (TypeError, ValueError, InvalidOperation):
            raise serializers.ValidationError("Invalid latitude value")

    def validate_longitude(self, value):
        """Additional validation for longitude"""
        try:
            decimal_val = Decimal(str(value))
            if decimal_val < -180 or decimal_val > 180:
                raise serializers.ValidationError("Longitude must be between -180 and 180")
            return decimal_val.quantize(Decimal('0.000001'), rounding=ROUND_DOWN)
        except (TypeError, ValueError, InvalidOperation):
            raise serializers.ValidationError("Invalid longitude value")

class LocationQuerySerializer(serializers.Serializer):
    lat = serializers.FloatField(min_value=-90, max_value=90)
    lng = serializers.FloatField(min_value=-180, max_value=180)
    region = serializers.CharField(required=False, allow_null=True, allow_blank=True)

    def validate_region(self, value):
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
        if 'region' in data and data['region']:
            data = data.copy()
            data['region'] = str(data['region']).strip().upper()
        return super().to_internal_value(data)