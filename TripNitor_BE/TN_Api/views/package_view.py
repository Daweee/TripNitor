from rest_framework import status
from rest_framework.views import APIView
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from ..serializers import PackageSerializer, FareCalculationSerializer, JoinPackageSerializer
from TN_Api.models import Package
from django.db import IntegrityError
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin
from ..services import PackageService

@extend_schema(tags=['packages'])
class PackageCreateView(CustomResponseMixin, CreateAPIView):
    queryset = Package.objects.all()
    serializer_class = PackageSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        package = serializer.save()
        
        return self.get_custom_response(
            status.HTTP_201_CREATED,
            serializer.data,
            'Package created successfully'
        )

@extend_schema(tags=['packages'])
class PackageListView(CustomResponseMixin, ListAPIView):
    queryset = Package.objects.select_related('start_location', 'final_destination').prefetch_related('legs')
    serializer_class = PackageSerializer

    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK, 
            serializer.data, 
            'Package list retrieved successfully.'
        )

@extend_schema(tags=['packages'])
class PackageDetailView(CustomResponseMixin, RetrieveAPIView):
    queryset = Package.objects.select_related('start_location', 'final_destination').prefetch_related('legs')
    serializer_class = PackageSerializer

    def get(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return self.get_custom_response(
            status.HTTP_200_OK, 
            serializer.data, 
            'Package details retrieved successfully.'
        )

@extend_schema(tags=['packages'])
class CalculatePackageFareView(CustomResponseMixin, APIView):
    serializer_class = FareCalculationSerializer

    def post(self, request, *args, **kwargs):
        serializer = FareCalculationSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        total_distance = serializer.validated_data['total_distance']

        package_service = PackageService()
        calculated_fare = package_service.calculate_base_fare(total_distance)

        response_data = {
            'fare': calculated_fare,
            'total_distance': total_distance
        }

        return self.get_custom_response(
            status.HTTP_200_OK,
            response_data,
            'Package fare calculated successfully'
        )

@extend_schema(tags=['packages'])
class PackageUpdateView(CustomResponseMixin, UpdateAPIView):
    queryset = Package.objects.select_related('start_location', 'final_destination').prefetch_related('legs')
    serializer_class = PackageSerializer

    def patch(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        # print("Validated data:", serializer.validated_data)
        updated_package = PackageService.update_package(instance, serializer.validated_data)
        output_serializer = self.get_serializer(updated_package)
        
        return self.get_custom_response(
            status.HTTP_200_OK,
            output_serializer.data,
            'Package updated successfully'
        )

@extend_schema(tags=['packages'])
class PackageDeleteView(CustomResponseMixin, DestroyAPIView):
    queryset = Package.objects.select_related('start_location', 'final_destination')
    serializer_class = PackageSerializer

    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return self.get_custom_response(
            status.HTTP_204_NO_CONTENT, 
            None,
            'Package deleted successfully'
        )

@extend_schema(tags=['packages'])
class JoinPackageView(CustomResponseMixin, APIView):
    serializer_class = JoinPackageSerializer
    
    def post(self, request, pk, *args, **kwargs):
        data = request.data.copy()
        
        if 'user_id' not in data:
            data['user_id'] = request.user.id
            
        serializer = JoinPackageSerializer(data=data)
        serializer.is_valid(raise_exception=True)
        
        try:
            package_user = PackageService.join_package(
                package_id=pk, 
                user_id=serializer.validated_data['user_id'],
                number_of_passengers=serializer.validated_data['number_of_passengers']
            )

            response_data = {
                'id': package_user.id,
                'user': package_user.user.username,
                'package': package_user.package.package_name if hasattr(package_user.package, 'package_name') else str(package_user.package),
                'number_of_passengers': package_user.number_of_passengers,
                'joined_at': package_user.joined_at
            }
            
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                response_data,
                'Successfully joined package'
            )
            
        except ValueError as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                {'error': str(e)},
                'Failed to join package'
            )