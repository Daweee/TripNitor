from rest_framework import serializers
from TN_Api.models import User
from rest_framework_simplejwt.tokens import RefreshToken, TokenError
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'name', 'email', 'phone_number', 'role', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            name=validated_data['name'],
            email=validated_data['email'],
            phone_number=validated_data['phone_number'],
            role=validated_data.get('role', User.Role.USER),
            password=validated_data['password']
        )
        return user

class LoginSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        
        data.update({
            'user_id': self.user.id,
            'username': self.user.username,
            'email': self.user.email,
            'name': self.user.name,
            'phone_number': self.user.phone_number,
            'role': self.user.role,
        })
        
        return data

class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()
