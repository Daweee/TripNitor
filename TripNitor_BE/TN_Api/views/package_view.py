from rest_framework import status
from rest_framework.response import Response
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
                f'Package creation failed with error {str(e)}.'
            )

@extend_schema(tags=['packages'])
class PackageListView(CustomResponseMixin, ListAPIView):
    queryset = Package.objects.all()
    serializer_class = PackageSerializer

    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK, 
            {'packages': serializer.data}, 
            'Package list retrieved successfully.'
        )

@extend_schema(tags=['packages'])
class PackageDetailView(CustomResponseMixin, RetrieveAPIView):
    queryset = Package.objects.all()
    serializer_class = PackageSerializer

    def get(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return self.get_custom_response(
             status.HTTP_200_OK, 
             {'package': serializer.data}, 
             'Package details retrieved successfully.'
        )

@extend_schema(tags=['packages'])
class PackageUpdateView(CustomResponseMixin, UpdateAPIView):
    queryset = Package.objects.all()
    serializer_class = PackageSerializer

@extend_schema(tags=['packages'])
class PackageDeleteView(CustomResponseMixin, DestroyAPIView):
    queryset = Package.objects.all()
    serializer_class = PackageSerializer

    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return self.get_custom_response(
            status.HTTP_204_NO_CONTENT, 
            None,
            'Package deleted successfully.'
        )
