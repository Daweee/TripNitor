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
from ..serializers import PackageSerializer
from TN_Api.models import Package
from django.db import IntegrityError
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin

@extend_schema(tags=['packages'])
class PackageCreateView(CustomResponseMixin, CreateAPIView):
    queryset = Package.objects.all()
    permission = [IsAuthenticated]
    serializer_class = PackageSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            package = serializer.save()
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                {'package': serializer.data},
                'Package created successfully'
            )
        except IntegrityError as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                f'{e}'
            )

@extend_schema(tags=['packages'])
class PackageListView(CustomResponseMixin, ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = PackageSerializer
    queryset = Package.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK,
            {'package': serializer.data},
            'Package list retrieved successfully'
        )

@extend_schema(tags=['packages'])
class PackageDetailView(CustomResponseMixin, RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = PackageSerializer
    queryset = Package.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return self.get_custom_response(
            status.HTTP_200_OK,
            {'package': serializer.data},
            'Package details retrieved successfully'
        )

@extend_schema(tags=['packages'])
class PackageUpdateView(CustomResponseMixin, UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = PackageSerializer
    queryset = Package.objects.all()

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        package = serializer.save()
        return self.get_custom_response(
            status.HTTP_200_OK,
            {'package': serializer.data},
            'Package details updated successfully'
        )

@extend_schema(tags=['packages'])
class PackageDeleteView(CustomResponseMixin, DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Package.objects.all()
    serializer_class = PackageSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return self.get_custom_response(
            status.HTTP_204_NO_CONTENT,
            None,
            'Package deleted successfully'
        )