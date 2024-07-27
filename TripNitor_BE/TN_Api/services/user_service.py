from ..models import User
from ..serializers import UserSerializer
from rest_framework import status
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from django.shortcuts import get_object_or_404

def create_user(user):
    user_serializer = UserSerializer(data=user)
    if user_serializer.is_valid():
        user = user_serializer.save()
        token, created = Token.objects.get_or_create(user=user)
        return user_serializer.data, token, status.HTTP_201_CREATED
    else:
        return user_serializer.errors, None, status.HTTP_400_BAD_REQUEST

def authenticate_user(user_data):
    user = get_object_or_404(User, username=user_data['username'])
    if not user.check_password(user_data['password']):
        return {'error': 'Not Found'}, None, status.HTTP_401_UNAUTHORIZED
    token, created = Token.objects.get_or_create(user=user)
    user_serializer = UserSerializer(user)
    return user_serializer.data, token.key, status.HTTP_200_OK