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
from ..serializers import VanSerializer
from django.db import IntegrityError
from django.db.models.deletion import ProtectedError, RestrictedError
from TN_Api.models import Van
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin

@extend_schema(tags=['vans'])
class VanCreateView(CustomResponseMixin,  CreateAPIView):
    serializer_class = VanSerializer
    permission = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            van = serializer.save()
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                serializer.data,
                'Van created successfully'
            )
        except IntegrityError as e:
            field_name = 'Unknown'
            if 'plate_number' in str(e):
                field_name = 'Plate Number'
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                f'A van with this {field_name} already exists.'
            )

@extend_schema(tags=['vans'])        
class VanListView(CustomResponseMixin, ListAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)

        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Van list retrieved successfully'
        )

@extend_schema(tags=['vans'])    
class VanDetailView(CustomResponseMixin, RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Van details retrieved successfully'
        )

@extend_schema(tags=['vans'])    
class VanUpdateView(CustomResponseMixin, UpdateAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        van = serializer.save()

        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Van details updated successfully'
        )

@extend_schema(tags=['vans'])    
class VanDeleteView(CustomResponseMixin, DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        try:
            self.perform_destroy(instance)
            return self.get_custom_response(
                status.HTTP_204_NO_CONTENT,
                None,
                'Van deleted successfully'
            )
        except (ProtectedError, RestrictedError):
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,  
                None,
                'This van cannot be deleted because it is referenced by other records'
            )
    
@extend_schema(tags=['vans'])
class UnassignedVanListView(CustomResponseMixin, ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = VanSerializer

    def get_queryset(self):
        return Van.objects.exclude(
            assigned_drivers__user__is_active=True
        )

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)

        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Available vans retrieved successfully'
        )