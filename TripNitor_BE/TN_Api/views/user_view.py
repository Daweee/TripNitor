from ..serializers import (
    UserSerializer, 
    LoginSerializer, 
    LogoutSerializer
)
from rest_framework.generics import (
    GenericAPIView,
    # ListApiView,
    RetrieveAPIView,
    CreateAPIView,
    # UpdateAPIView,
    # DestroyAPIView
)
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.views import TokenObtainPairView
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin
from TN_Api.models import User

@extend_schema(tags=['users'])
class RegisterView(CustomResponseMixin, CreateAPIView):
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
    
    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        refresh = RefreshToken.for_user(user)
        access_token = str(refresh.access_token)

        token = {
            "refresh": str(refresh),
            "access": access_token,
        }
        return self.get_custom_response(
            status.HTTP_201_CREATED,
            {'user': serializer.data, 'token': token},
            'User created successfully'
        )

class LoginView(CustomResponseMixin, TokenObtainPairView):
    serializer_class = LoginSerializer
    permission_classes = [AllowAny]

    @extend_schema(tags=['users'])
    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        try:
            serializer.is_valid(raise_exception=True)
            user_data = {
                'id': serializer.validated_data.get('user_id'),
                'username': serializer.validated_data.get('username'),
                'email': serializer.validated_data.get('email'),
                'name': serializer.validated_data.get('name'),
                'phone_number': serializer.validated_data.get('phone_number'),
                'role': serializer.validated_data.get('role'),
                'token': {
                    'access': str(serializer.validated_data.get('access')),
                    'refresh': str(serializer.validated_data.get('refresh'))
                }
            }

            return self.get_custom_response(
                status.HTTP_200_OK,
                user_data,
                'User login successfully'
            )
        except Exception as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                'Invalid Credentials'
            )
        
class LogoutView(CustomResponseMixin, GenericAPIView):
    serializer_class = LogoutSerializer
    permission_classes = [IsAuthenticated]

    @extend_schema(tags=['users'])
    def post(self, request):
        serializer = LogoutSerializer(data=request.data)

        if serializer.is_valid(raise_exception=True):
            try:
                refresh_token = request.data["refresh"]
                token = RefreshToken(refresh_token)
                token.blacklist()

                return self.get_custom_response(
                    status.HTTP_205_RESET_CONTENT,
                    None,
                    'User logged out successfully'
                )
            except Exception as e:
                return self.get_custom_response(
                    status.HTTP_400_BAD_REQUEST, 
                    None,
                    e
                )
        return self.get_custom_response(
            status.HTTP_400_BAD_REQUEST, 
            None,
            serializer.errors
        )

@extend_schema(tags=['users'])
class UserDetailView(CustomResponseMixin, RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer
    queryset = User.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'User details retrieved successfully'
        )