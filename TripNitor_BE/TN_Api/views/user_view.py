from ..serializers import UserSerializer, LoginSerializer
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from ..services import create_user, authenticate_user
from rest_framework import status

class SignupView(GenericAPIView):
    serializer_class = UserSerializer

    def post(self, request):
        user_data = request.data
        if user_data:
            user, token, status_code = create_user(user_data)
            response_data = {'user': user, 'token': token.key}
            return Response(response_data, status=status_code)
        else:
            return Response({'error': 'Invalid user data'}, status=400)
        
class LoginView(GenericAPIView):
    serializer_class = LoginSerializer

    def post(self, request):
        user_data = request.data
        user, token, status_code = authenticate_user(user_data)
        if status_code == status.HTTP_200_OK:
            response_data = {'user': user, 'token': token}
            return Response(response_data, status=status_code)
        else:
            return Response(user, status=status_code)