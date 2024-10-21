from rest_framework import serializers
from ..models import Van, Gas
from .gas_serializer import GasSerializer

class VanSerializer(serializers.ModelSerializer):
    gas = GasSerializer(read_only=True)
    gas_id = serializers.PrimaryKeyRelatedField(
        queryset=Gas.objects.all(),
        source='gas',
        write_only=True,
        required=False,
        allow_null=True
    )

    class Meta:
        model = Van
        fields = ['id', 'model', 'plate_number', 'date_bought', 'registration_expiry_date', 'max_passengers', 'gas', 'gas_id']

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation.pop('gas_id', None)
        return representation