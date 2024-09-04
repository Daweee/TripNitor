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
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin

@extend_schema(tags=['gases'])
class GasCreateView(CustomResponseMixin, CreateAPIView):
    serializer_class = GasSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            gas = serializer.save()
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                {'gas': serializer.data},
                'Gas created successfully'
            )
        except IntegrityError as e:
            field_name = 'Unknown'
            if 'gas_name' in str(e):
                field_name = 'Gas Name'
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                f'A gas with this {field_name} already exists.'
            )

@extend_schema(tags=['gases'])        
class GasListView(CustomResponseMixin, ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = GasSerializer
    queryset = Gas.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        return self.get_custom_response(
            status.HTTP_200_OK,
            {'gases': serializer.data},
            'Gas list retrieved successfully'
        )

@extend_schema(tags=['gases'])
class GasDetailView(CustomResponseMixin, RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = GasSerializer
    queryset = Gas.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        return self.get_custom_response(
            status.HTTP_200_OK,
            {'gas': serializer.data},
            'Gas details retrieved successfully'
        )

@extend_schema(tags=['gases'])
class GasUpdateView(CustomResponseMixin, UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = GasSerializer
    queryset = Gas.objects.all()

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        gas = serializer.save()

        return self.get_custom_response(
            status.HTTP_200_OK,
            {'gases': serializer.data},
            'Gas details updated successfully'
        )

@extend_schema(tags=['gases'])
class GasDeleteView(CustomResponseMixin, DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Gas.objects.all()
    serializer_class = GasSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)

        return self.get_custom_response(
            status.HTTP_204_NO_CONTENT,
            None,
            'Gas deleted successfully'
        )