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
    description='Validate if a location is within a specified region boundary',
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
        OpenApiParameter(
            name='region',
            type=str,
            location=OpenApiParameter.QUERY,
            description='Region to check (NORTH, SOUTH, CITY). If not specified, checks against entire CEBU province.',
            required=False
        ),
    ],
    responses={
        200: {"type": "object", "properties": {
            "status": {"type": "string"},
            "data": {
                "type": "object",
                "properties": {
                    "is_within_boundary": {"type": "boolean"},
                    "region": {"type": "string", "nullable": True}
                }
            },
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
                "Invalid parameters: " + str(query_serializer.errors),
            )
                
        try:
            lat = query_serializer.validated_data['lat']
            lng = query_serializer.validated_data['lng']
            region = query_serializer.validated_data.get('region')
            
            is_within = self.location_service.is_point_within_boundary(lat, lng, region)
            
            response_data = {
                "is_within_boundary": is_within,
                "region": region
            }
            
            region_name = region if region else "Cebu Province"
            message = f"Location is {'within' if is_within else 'outside'} {region_name}"
            
            return self.get_custom_response(
                status.HTTP_200_OK,
                response_data,
                message,
            )
            
        except Exception as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                str(e),
            )