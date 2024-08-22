from rest_framework import serializers
from TN_Api.models import Driver, User

class UserDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'name', 'phone_number', 'role']

class DriverSerializer(serializers.ModelSerializer):
    user = UserDetailSerializer(read_only=True)

    class Meta:
        model = Driver
        fields = ['user', 'license_number', 'date_hired']

    def update(self, instance, validated_data):
        instance.license_number = validated_data.get('license_number', instance.license_number)
        instance.date_hired = validated_data.get('date_hired', instance.date_hired)
        instance.save()
        return instance

class DriverCreationSerializer(serializers.ModelSerializer):
    # nesting user fields inside the driver serializer
    username = serializers.CharField(source='user.username', max_length=255)
    name = serializers.CharField(source='user.name', max_length=255)
    email = serializers.EmailField(source='user.email')
    phone_number = serializers.CharField(source='user.phone_number', max_length=20)
    password = serializers.CharField(write_only=True, source='user.password')

    class Meta:
        model = Driver
        fields = ['username', 'name', 'email', 'phone_number', 'password', 'license_number', 'date_hired']

    def create(self, validated_data):
        # extract the user data
        user_data = validated_data.pop('user')
        password = user_data.pop('password')

        # create the User with the role of Driver
        user = User.objects.create_user(
            password=password,
            role=User.Role.DRIVER,
            **user_data
        )

        # create the driver profile associated with the user
        driver = Driver.objects.create(user=user, **validated_data)
        
        return driver