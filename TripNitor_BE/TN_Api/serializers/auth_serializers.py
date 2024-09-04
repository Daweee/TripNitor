from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from ..models import Driver

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

        if self.user.role == self.user.Role.DRIVER:
            try:
                driver = Driver.objects.get(user=self.user)
                data.update({
                    'license_number': driver.license_number,
                    'date_hired': driver.date_hired,
                })
            except Driver.DoesNotExist:
                pass  
        
        return data
    
class LogoutSerializer(serializers.Serializer):
    refresh = serializers.CharField()