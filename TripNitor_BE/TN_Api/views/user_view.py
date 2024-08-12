from ..serializers import UserSerializer, LoginSerializer, LogoutSerializer
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from ..services import create_user, authenticate_user, logout_user
from rest_framework import status, permissions
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework_simplejwt.authentication import JWTAuthentication

class SignupView(GenericAPIView):
    serializer_class = UserSerializer

    permission_classes = [AllowAny]
    
    def post(self, request):
        user_data = request.data
        user, token, status_code = create_user(user_data)
        if status_code == status.HTTP_201_CREATED:
            response_data = {
                'status': status_code, 
                'data': {'user': user, 'token': token}, 
                'message': 'User created successfully'
            }
            return Response(response_data, status=status_code)
        else:
            response_data = {
                'status': status_code, 
                'data': None,
                'message': 'User creation failed'
            }
            return Response(response_data, status=status_code)
        
class LoginView(GenericAPIView):
    serializer_class = LoginSerializer

    permission_classes = [AllowAny]

    def post(self, request):
        user_data = request.data
        user, token, status_code = authenticate_user(user_data)
        if status_code == status.HTTP_200_OK:
            response_data = {
                'status': status_code, 
                'data': {'user': user, 'token': token}, 
                'message': 'User login successfully'
            }
            return Response(response_data, status=status_code)
        else:
            response_data = {
                'status': status_code, 
                'data': user, 
                'message': 'Invalid credentials'
            }
            return Response(response_data, status=status_code)
        
class LogoutView(GenericAPIView):
    serializer_class = LogoutSerializer

    # permission_classes = (permissions.IsAuthenticated,)
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        refresh_token = request.data["refresh"]
        logout_status = logout_user(refresh_token)
        if logout_status == status.HTTP_205_RESET_CONTENT:
            response_data = {
                'status': logout_status, 
                'data': None, 
                'message': 'User logged out successfully'
            }
            return Response(response_data, status=logout_status)
        else:
            response_data = {
                'status': logout_status, 
                'data': None, 
                'message': 'Invalid token'
            }
            return Response(response_data, status=logout_status)
            
              
