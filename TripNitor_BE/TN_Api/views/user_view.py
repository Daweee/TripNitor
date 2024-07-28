from ..serializers import UserSerializer, LoginSerializer
from rest_framework.generics import GenericAPIView
from rest_framework.response import Response
from ..services import create_user, authenticate_user
from rest_framework import status, permissions

class SignupView(GenericAPIView):
    serializer_class = UserSerializer

    def post(self, request):
        user_data = request.data
        if user_data:
            user, token, status_code = create_user(user_data)
            response_data = {
                'status': status_code, 
                'data': {'user': user, 'token': token}, 
                'message': 'User created successfully'
            }
            return Response(response_data, status=status_code)
        else:
            response_data = {
                'status': 400, 
                'data': None,
                'message': 'Invalid data'
            }
            return Response(response_data, status=400)
        
class LoginView(GenericAPIView):
    serializer_class = LoginSerializer

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
        
# class LogoutView(GenericAPIView):
#     serializer_class = LogoutSerializer

#     # permission_classes = (permissions.IsAuthenticated,)

#     def post(self, request):
#         auth_header = request.META.get('HTTP_AUTHORIZATION')
#         print(f'Auth Header: {auth_header}')
#         if not auth_header or len(auth_header.split(' ')) != 2:
#             return Response({'detail': 'Authorization header must contain two space-delimited values hmm', 'code': 'bad_authorization_header'}, status=400)
#         user_data = request.data
#         if user_data:
#             status = logout_user(user_data)
#             return Response(status=status)
#         else:
#             response_data = {
#                 'status': 400, 
#                 'data': None,
#                 'message': 'Bad token'
#             }
#             return Response(response_data, status=400)