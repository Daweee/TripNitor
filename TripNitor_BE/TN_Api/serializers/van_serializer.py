from rest_framework import serializers
from TN_Api.models import Van
from TN_Api.serializers import GasSerializer

class VanSerializer(serializers.ModelSerializer):
    gas = GasSerializer(read_only=True) 

    class Meta:
        model = Van
        fields = ['id', 'model', 'plate_number', 'date_bought', 'registration_expiry_date', 'max_passengers', 'gas']