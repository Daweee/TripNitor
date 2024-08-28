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

class PackageCreateView(CreateAPIView):
    queryset = Package.objects.all()
    permission = [IsAuthenticated]
    serializer_class = PackageSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            package = serializer.save()
            response_data = {
                'status': status.HTTP_201_CREATED,
                'data': {'package': serializer.data},
                'message': 'Package created successfully'
            }
            return Response(response_data, status=status.HTTP_201_CREATED)
        except IntegrityError as e:
            response_data = {
                'status': status.HTTP_400_BAD_REQUEST,
                'data': None,
                'message': f'{e}'
            }
            return Response(response_data, status=status.HTTP_400_BAD_REQUEST)

class PackageListView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = PackageSerializer
    queryset = Package.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'packages': serializer.data},
            'message': 'Package list retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

class PackageDetailView(RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = PackageSerializer
    queryset = Package.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'package': serializer.data},
            'message': 'Package details retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)


class PackageUpdateView(UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = PackageSerializer
    queryset = Package.objects.all()

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        package = serializer.save()
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'package': serializer.data},
            'message': 'Package details updated successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)


class PackageDeleteView(DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Package.objects.all()
    serializer_class = PackageSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        response_data = {
            'status': status.HTTP_204_NO_CONTENT,
            'data': None,
            'message': 'Package deleted successfully'
        }
        return Response(response_data, status=status.HTTP_204_NO_CONTENT)