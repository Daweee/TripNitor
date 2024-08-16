from ..serializers import (
    UserSerializer, 
    LoginSerializer, 
    LogoutSerializer
)
from rest_framework.generics import (
    GenericAPIView,
    # ListApiView,
    # RetrieveAPIView,
    CreateAPIView,
    # UpdateAPIView,
    # DestroyAPIView
)
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.views import TokenObtainPairView

class RegisterView(CreateAPIView):
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

        response_data = {
            'status': status.HTTP_201_CREATED, 
            'data': {'user': serializer.data, 'token': token}, 
            'message': 'User created successfully'
        }

        return Response(response_data, status=status.HTTP_201_CREATED)
        
class LoginView(TokenObtainPairView):
    serializer_class = LoginSerializer
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        try:
            serializer.is_valid(raise_exception=True)
            token = {
                'access': str(serializer.validated_data.get('access')),
                'refresh': str(serializer.validated_data.get('refresh'))
            }

            response_data = {
                'status': status.HTTP_200_OK,
                'data': {
                    'user': {
                        'id': serializer.validated_data.get('user_id'),
                        'username': serializer.validated_data.get('username'),
                        'email': serializer.validated_data.get('email'),
                        'name': serializer.validated_data.get('name'),
                        'phone_number': serializer.validated_data.get('phone_number'),
                        'role': serializer.validated_data.get('role'),
                    },
                    'token': token
                },
                'message': 'User login successfully'
            }
            return Response(response_data, status=status.HTTP_200_OK)
        except Exception as e:
            response_data = {
                'status': status.HTTP_400_BAD_REQUEST, 
                'data': None, 
                'message': str(e)
            }
            return Response(response_data, status=status.HTTP_400_BAD_REQUEST)
        
class LogoutView(GenericAPIView):
    serializer_class = LogoutSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = LogoutSerializer(data=request.data)

        if serializer.is_valid(raise_exception=True):
            try:
                refresh_token = request.data["refresh"]
                token = RefreshToken(refresh_token)
                token.blacklist()

                response_data = {
                    'status': status.HTTP_205_RESET_CONTENT, 
                    'data': None, 
                    'message': 'User logged out successfully'
                }

                return Response(response_data, status=status.HTTP_205_RESET_CONTENT)
            except Exception as e:
                response_data = {
                    'status': status.HTTP_400_BAD_REQUEST, 
                    'data': None, 
                    'message': e
                }
                return Response(response_data, status=status.HTTP_400_BAD_REQUEST)
        response_data = {
            'status': status.HTTP_400_BAD_REQUEST, 
            'data': None, 
            'message': serializer.errors
        }
        return Response(response_data, status=status.HTTP_400_BAD_REQUEST)
