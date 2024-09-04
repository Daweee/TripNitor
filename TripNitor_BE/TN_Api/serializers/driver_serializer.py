from rest_framework import serializers
from ..models import Driver, User, Van
from .user_serializer import UserSerializer
from .van_serializer import VanSerializer
from django.db import transaction

class DriverSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    van = VanSerializer(read_only=True)

    class Meta:
        model = Driver
        fields = ['user', 'license_number', 'date_hired', 'van']

    def update(self, instance, validated_data):
        instance.license_number = validated_data.get('license_number', instance.license_number)
        instance.date_hired = validated_data.get('date_hired', instance.date_hired)
        instance.save()
        return instance

class DriverCreationSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', max_length=255)
    name = serializers.CharField(source='user.name', max_length=255)
    email = serializers.EmailField(source='user.email')
    phone_number = serializers.CharField(source='user.phone_number', max_length=20)
    password = serializers.CharField(write_only=True, source='user.password')
    van_id = serializers.PrimaryKeyRelatedField(queryset=Van.objects.all(), source='van')

    class Meta:
        model = Driver
        fields = ['username', 'name', 'email', 'phone_number', 'password', 'license_number', 'date_hired', 'van_id']

    def validate_van_id(self, value):
        if Driver.objects.filter(van=value).exists():
            raise serializers.ValidationError("This van is already assigned to a driver.")
        return value

    @transaction.atomic
    def create(self, validated_data):
        user_data = validated_data.pop('user')
        password = user_data.pop('password')
        van = validated_data.pop('van')

        user = User.objects.create_user(
            password=password,
            role=User.Role.DRIVER,
            **user_data
        )

        try:
            driver = Driver.objects.create(user=user, van=van, **validated_data)
        except Exception as e:
            user.delete()
            raise serializers.ValidationError(str(e))
        
        return driver