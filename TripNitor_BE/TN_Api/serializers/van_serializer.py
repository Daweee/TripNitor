from rest_framework import serializers
from TN_Api.models import Van, Gas

class GasDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Gas
        fields = ['id', 'gas_name', 'gas_price']

class VanSerializer(serializers.ModelSerializer):
    gas = GasDetailSerializer(read_only=True) 

    class Meta:
        model = Van
        fields = ['id', 'model', 'plate_number', 'date_bought', 'registration_expiry_date', 'max_passengers', 'gas']