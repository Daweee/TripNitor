from rest_framework.response import Response

class CustomResponseMixin:
    def get_custom_response(self, status_code, data=None, message=None):
        return Response({
            'status': status_code,
            'data': data,
            'message': message
        }, status=status_code)