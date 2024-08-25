from rest_framework import serializers
from TN_Api.models import Gas

class GasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Gas
        fields = ['id', 'gas_name', 'gas_price']
