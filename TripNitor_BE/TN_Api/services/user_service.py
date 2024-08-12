from ..models import User
from ..serializers import UserSerializer, LogoutSerializer
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from django.shortcuts import get_object_or_404
from rest_framework_simplejwt.exceptions import TokenError

def create_user(user):
    user_serializer = UserSerializer(data=user)
    if user_serializer.is_valid():
        user = user_serializer.save()
        token = RefreshToken.for_user(user)
        return user_serializer.data, {'access': str(token.access_token), 'refresh': str(token)}, status.HTTP_201_CREATED
    else:
        # errors = [f"{field}: {message}" for field, messages in user_serializer.errors.items() for message in messages] 
        return None, None, status.HTTP_400_BAD_REQUEST

def authenticate_user(user_data):
    try:
        user = User.objects.get(username=user_data['username'])
    except User.DoesNotExist:
        return None, None, status.HTTP_401_UNAUTHORIZED

    if not user.check_password(user_data['password']):
        return None, None, status.HTTP_401_UNAUTHORIZED

    token = RefreshToken.for_user(user)
    user_serializer = UserSerializer(user)
    return user_serializer.data, {'access': str(token.access_token), 'refresh': str(token)}, status.HTTP_200_OK

def logout_user(refresh_token):
    try:
        token = RefreshToken(refresh_token)
        token.blacklist()
        return status.HTTP_205_RESET_CONTENT
    except TokenError:
        return status.HTTP_400_BAD_REQUEST