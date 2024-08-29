from rest_framework import serializers
from ..models import Package
from .leg_serializer import LegSerializer

class PackageSerializer(serializers.ModelSerializer):
    legs = LegSerializer(many=True)

    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'package_type', 'visibility', 'legs']

    def create(self, validated_data):
        legs_data = validated_data.pop('legs')
        package = Package.objects.create(**validated_data)
        for leg_data in legs_data:
            LegSerializer().create(validated_data={**leg_data, 'package': package})
        return package

    def update(self, instance, validated_data):
        legs_data = validated_data.pop('legs', None)
        instance = super().update(instance, validated_data)

        if legs_data is not None:
            instance.legs.all().delete()
            for leg_data in legs_data:
                LegSerializer().create(validated_data={**leg_data, 'package': instance})

        return instance