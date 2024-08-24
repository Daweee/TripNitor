from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from ..serializers import GasSerializer
from TN_Api.models import Gas
from django.db import IntegrityError

class GasCreateView(CreateAPIView):
    serializer_class = GasSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            gas = serializer.save()
            response_data = {
                'status': status.HTTP_201_CREATED,
                'data': {'gas': serializer.data},
                'message': 'Gas created successfully'
            }
            return Response(response_data, status=status.HTTP_201_CREATED)
        except IntegrityError as e:
            field_name = 'Unknown'
            if 'gas_name' in str(e):
                field_name = 'Gas Name'
            response_data = {
                'status': status.HTTP_400_BAD_REQUEST,
                'data': None,
                'message': f'A gas with this {field_name} already exists.'
            }
            return Response(response_data, status=status.HTTP_400_BAD_REQUEST)
        
class GasListView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = GasSerializer
    queryset = Gas.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'gases': serializer.data},
            'message': 'Gas list retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

class GasDetailView(RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = GasSerializer
    queryset = Gas.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'gas': serializer.data},
            'message': 'Gas details retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

class GasUpdateView(UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = GasSerializer
    queryset = Gas.objects.all()

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        gas = serializer.save()

        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'gas': serializer.data},
            'message': 'Gas details updated successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

class GasDeleteView(DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Gas.objects.all()
    serializer_class = GasSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)

        response_data = {
            'status': status.HTTP_204_NO_CONTENT,
            'data': None,
            'message': 'Gas deleted successfully'
        }
        return Response(response_data, status=status.HTTP_204_NO_CONTENT)