from ..models import User
from ..serializers import UserSerializer
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from django.shortcuts import get_object_or_404

def create_user(user):
    user_serializer = UserSerializer(data=user)
    if user_serializer.is_valid():
        user = user_serializer.save()
        token = RefreshToken.for_user(user)
        return user_serializer.data, {'access': str(token.access_token), 'refresh': str(token)}, status.HTTP_201_CREATED
    else:
        return user_serializer.errors, None, status.HTTP_400_BAD_REQUEST

def authenticate_user(user_data):
    user = get_object_or_404(User, username=user_data['username'])
    if not user.check_password(user_data['password']):
        return None, None, status.HTTP_401_UNAUTHORIZED
    token = RefreshToken.for_user(user)
    user_serializer = UserSerializer(user)
    return user_serializer.data, {'access': str(token.access_token), 'refresh': str(token)}, status.HTTP_200_OK

# def logout_user(user):
#     user_serializer = LogoutSerializer(data=user)
#     user_serializer.is_valid()
#     user_serializer.save()
#     return status.HTTP_204_NO_CONTENT