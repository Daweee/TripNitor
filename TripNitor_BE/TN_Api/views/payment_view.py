from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from drf_spectacular.utils import extend_schema
from ..serializers import PaymentProcessSerializer
from ..services.payment_service import PaymentService
from .mixins import CustomResponseMixin

@extend_schema(tags=['payments'])
class ProcessPaymentView(CustomResponseMixin, APIView):
    serializer_class = PaymentProcessSerializer
    
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        payment_service = PaymentService()
        result = payment_service.process_booking_payment(
            serializer.validated_data['amount'],
            serializer.validated_data['currency'],
            request.user
        )
        
        if result['success']:
            return self.get_custom_response(
                status.HTTP_200_OK,
                result,
                result['status']
            )
        else:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                result,
                result['status']
            )