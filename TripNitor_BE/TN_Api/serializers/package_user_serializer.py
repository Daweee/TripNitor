from rest_framework import serializers
from ..models import User, Package, PackageUser
from ..serializers import UserMinimalSerializer, PackageMinimalSerializer

class PackageUserSerializer(serializers.ModelSerializer):
    user = UserMinimalSerializer(read_only=True)
    package = PackageMinimalSerializer(read_only=True)

    class Meta:
        model = PackageUser
        fields = ['id', 'user', 'package', 'number_of_passengers', 'joined_at']