from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from ..models import DriverAssignment, Driver, Booking
from ..serializers import DriverAssignmentSerializer, DriverSerializer
from ..services import DriverAssignmentService
from drf_spectacular.utils import extend_schema, OpenApiParameter
from drf_spectacular.types import OpenApiTypes
from .mixins import CustomResponseMixin
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from rest_framework.exceptions import NotFound

@extend_schema(tags=['driver assignments'])
class DriverAssignmentList(CustomResponseMixin, ListAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer
    permission_classes = [IsAuthenticated]
    
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
   
        return self.get_custom_response(
                status.HTTP_200_OK, 
                serializer.data,
                'Driver assignment list retrieved successfully'
            )
    
@extend_schema(tags=['driver assignments'])
class DriverAssignmentByDriverList(CustomResponseMixin, ListAPIView):
    serializer_class = DriverAssignmentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        try:
            driver = Driver.objects.get(user=self.request.user)
            return DriverAssignment.objects.filter(driver=driver)
        except Driver.DoesNotExist:
            raise NotFound(detail="No driver profile found for the current user.")

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            if not queryset.exists():
                return self.get_custom_response(
                    status.HTTP_200_OK,
                    None,
                    'No driver assignments found for the current user'
                )
            serializer = self.get_serializer(queryset, many=True)
            return self.get_custom_response(
                status.HTTP_200_OK,
                serializer.data,
                'Driver booking list retrieved successfully'
            )
        except NotFound as e:
            return self.get_custom_response(
                status.HTTP_404_NOT_FOUND,
                None,
                str(e)
            )
        
@extend_schema(tags=['driver assignments'])
class DriverActiveBookingsList(CustomResponseMixin, ListAPIView):
    serializer_class = DriverAssignmentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        try:
            driver = Driver.objects.get(user=self.request.user)
            return DriverAssignment.objects.filter(
                driver=driver,
                booking__status__in=[
                    Booking.BookingStatus.CONFIRMED,
                    Booking.BookingStatus.ONGOING
                ]
            )
        except Driver.DoesNotExist:
            raise NotFound(detail="No driver profile found for the current user.")

    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            if not queryset.exists():
                return self.get_custom_response(
                    status.HTTP_200_OK,
                    None,
                    'No active bookings found for the current user'
                )
            serializer = self.get_serializer(queryset, many=True)
            return self.get_custom_response(
                status.HTTP_200_OK,
                serializer.data,
                'Active bookings list retrieved successfully'
            )
        except NotFound as e:
            return self.get_custom_response(
                status.HTTP_404_NOT_FOUND,
                None,
                str(e)
            )

@extend_schema(tags=['driver assignments'])
class DriverAssignmentCreate(CustomResponseMixin, CreateAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer

@extend_schema(tags=['driver assignments'])
class DriverAssignmentRetrieveList(CustomResponseMixin, ListAPIView):
    serializer_class = DriverAssignmentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        driver_id = self.kwargs.get('driver_id')
        queryset = DriverAssignment.objects.filter(driver__id=driver_id)
        if not queryset.exists():
            raise NotFound(detail="No driver assignments found for the specified driver.")
        return queryset

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Driver assignments retrieved successfully'
        )

@extend_schema(tags=['driver assignments'])
class DriverAssignmentUpdate(CustomResponseMixin, UpdateAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer

@extend_schema(tags=['driver assignments'])
class DriverAssignmentDestroy(CustomResponseMixin, DestroyAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverSerializer

@extend_schema(
    tags=['driver assignments'],
    parameters=[
        OpenApiParameter(
            name='booking_id',
            type=OpenApiTypes.STR,
            location=OpenApiParameter.QUERY,
            description='ID of the booking to find available drivers for',
            required=True
        ),
        OpenApiParameter(
            name='start_date',
            type=OpenApiTypes.DATETIME,
            location=OpenApiParameter.QUERY,
            description='Start date of the booking (format: YYYY-MM-DD HH:MM:SS)',
            required=True
        ),
        OpenApiParameter(
            name='end_date',
            type=OpenApiTypes.DATETIME,
            location=OpenApiParameter.QUERY,
            description='End date of the booking (format: YYYY-MM-DD HH:MM:SS)',
            required=True
        )
    ],
    responses={
        200: DriverSerializer(many=True),
        400: None,
        404: None
    }
)
class AvailableDriversForSwapView(CustomResponseMixin, ListAPIView):
    serializer_class = DriverSerializer

    def get(self, request, *args, **kwargs):
        booking_id = request.query_params.get('booking_id')
        start_date = request.query_params.get('start_date')
        end_date = request.query_params.get('end_date')
        
        available_drivers, error = DriverAssignmentService.get_available_drivers_for_swap(
            booking_id, start_date, end_date
        )
        
        if error:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                error
            )
            
        if not available_drivers or available_drivers.count() == 0:
            return self.get_custom_response(
                status.HTTP_200_OK,
                None,
                'No available drivers found for swap'
            )
            
        serializer = self.get_serializer(available_drivers, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Available drivers for swap retrieved successfully'
        )

