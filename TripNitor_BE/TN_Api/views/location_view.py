from rest_framework import status
from rest_framework.views import APIView
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from ..services.location_service import LocationService
from ..serializers import LocationQuerySerializer
from drf_spectacular.utils import extend_schema, OpenApiParameter
from .mixins import CustomResponseMixin

@extend_schema(
    tags=['locations'],
    description='Search for locations with various filters',
    parameters=[
        OpenApiParameter(
            name='lat',
            type=float,
            location=OpenApiParameter.QUERY,
            description='Latitude coordinate (-90 to 90)',
            required=True
        ),
        OpenApiParameter(
            name='lng',
            type=float,
            location=OpenApiParameter.QUERY,
            description='Longitude coordinate (-180 to 180)',
            required=True
        ),
    ],
    responses={
        200: {"type": "object", "properties": {
            "status": {"type": "string"},
            "data": {"type": "boolean"},
            "message": {"type": "string"}
        }},
        400: {"type": "object", "properties": {
            "status": {"type": "string"},
            "data": {"type": "null"},
            "message": {"type": "string"}
        }}
    }
)
class LocationValidationView(CustomResponseMixin, APIView):
    location_service = LocationService()
    serializer_class = LocationQuerySerializer

    def get(self, request):
        query_serializer = LocationQuerySerializer(data=request.query_params)
        if not query_serializer.is_valid():
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                "Invalid coordinates",
            )
                
        try:
            lat = query_serializer.validated_data['lat']
            lng = query_serializer.validated_data['lng']
            
            if self.location_service.is_point_within_boundary(lat, lng):
                return self.get_custom_response(
                    status.HTTP_200_OK,
                    True,
                    "Location is within boundary",
                )
            
            return self.get_custom_response(
                status.HTTP_200_OK,
                False,
                "Location is outside boundary",
            )
            
        except Exception as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                 str(e),
            )