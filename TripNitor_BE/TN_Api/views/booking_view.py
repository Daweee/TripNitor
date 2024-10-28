from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView,
)
from ..serializers import BookingSerializer, BookingCreationSerializer, BookingPreviewSerializer, BookingStatusUpdateSerializer
from ..models import Booking
from django.db import IntegrityError
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin
from django.db.models import Case, When, IntegerField

@extend_schema(tags=['bookings'])
class BookingListView(CustomResponseMixin, ListAPIView):
    serializer_class = BookingSerializer

    def get_queryset(self):
        return Booking.objects.all().order_by('-created_at')

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK, 
            serializer.data, 
            'Bookings retrieved successfully.'
        )
    
@extend_schema(tags=['bookings'])
class UserBookingListView(CustomResponseMixin, ListAPIView):
    serializer_class = BookingSerializer

    def get_queryset(self):
        user = self.request.user
        queryset = Booking.objects.filter(user=user)
        
        status_param = self.request.query_params.get('status', 'ALL').upper()
        
        if status_param != 'ALL':
            queryset = queryset.filter(status=status_param)
        
        return queryset.order_by('-created_at')
    
    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK, 
            serializer.data, 
            'User bookings retrieved successfully.'
        )

@extend_schema(tags=['bookings'])
class GetBookingStatusListView(ListAPIView):
    serializer_class = BookingSerializer

    def get_queryset(self):
        booking_status = self.kwargs['bookingstatus']
        return Booking.objects.filter(status=booking_status)

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return Response({
            'status': status.HTTP_200_OK,
            'data': serializer.data,
            'message': f'All bookings with status {self.kwargs["bookingstatus"]} retrieved successfully.'
        })
    
@extend_schema(tags=['bookings'])
class BookingCreateView(CustomResponseMixin, CreateAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingCreationSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        try:
            booking = serializer.save()
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                serializer.data,
                'Booking created successfully'
            )
        except IntegrityError as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                f'Book creation failed with error {str(e)}.'
            )
    
@extend_schema(tags=['bookings'])
class BookingDetailView(CustomResponseMixin, RetrieveAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

    def get(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return self.get_custom_response(
             status.HTTP_200_OK, 
             serializer.data, 
             'Booking details retrieved successfully.'
        )

@extend_schema(tags=['bookings'])
class BookingUpdateView(CustomResponseMixin, UpdateAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

@extend_schema(tags=['bookings'])
class BookingDeleteView(CustomResponseMixin, DestroyAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

    def delete(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return self.get_custom_response(
            status.HTTP_204_NO_CONTENT, 
            None,
            'Booking deleted successfully.'
        )

@extend_schema(tags=['bookings'])
class BookingPreviewView(APIView):
    serializer_class = BookingPreviewSerializer

    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            package = serializer.validated_data['package']
            start_date = serializer.validated_data['start_date']
            end_date = serializer.validated_data['end_date']
            number_of_passengers = serializer.validated_data['number_of_passengers']

            temp_booking = Booking(
                package=package,
                start_date=start_date,
                end_date=end_date,
                number_of_passengers=number_of_passengers
            )

            temp_booking.clean()  # Ensure validation is applied
            assigned_drivers = temp_booking.preview_driver_assignment()

            # number_of_vans = len(assigned_drivers) 
            temp_booking.calculate_final_fare(assigned_drivers)

            # Calculate total price
            total_price = temp_booking.total_price
            base_fare = temp_booking.base_fare
            number_of_nights = temp_booking.number_of_nights
            updated_package_fare = temp_booking.updated_package_fare

            # available_drivers = temp_booking.get_available_drivers()
            # required_vans = (number_of_passengers + 14) // 15
            # assigned_drivers = available_drivers[:required_vans]

            preview_data = {
                'package': package.package_name,
                'start_date': start_date,
                'end_date': end_date,
                'number_of_passengers': number_of_passengers,
                'base_fare': base_fare,
                'number_of_nights': number_of_nights,
                'base_package_price': updated_package_fare,
                'total_price': total_price,
                
                'assigned_drivers': [
                    {
                        'id': driver.id,
                        'name': driver.user.name,
                        'phone_number': driver.user.phone_number,
                        'van_model': driver.van.model,
                        'van_plate_number': driver.van.plate_number,
                    } for driver in assigned_drivers
                ]
            }
            return Response({
                'status': status.HTTP_200_OK,
                'data': preview_data,
                'message': 'Booking preview generated successfully.'
            })
        else:
            return Response({
                'status': status.HTTP_400_BAD_REQUEST,
                'data': serializer.errors,
                'message': 'Invalid data provided for booking preview.'
            }, status=status.HTTP_400_BAD_REQUEST)
        
@extend_schema(tags=['bookings'])
class ConfirmBookingView(CustomResponseMixin, UpdateAPIView):
    serializer_class = BookingStatusUpdateSerializer
    queryset = Booking.objects.all()

    def patch(self, request, pk):
        try:
            booking = Booking.objects.get(id=pk, status=Booking.BookingStatus.PENDING)
        except Booking.DoesNotExist:
            return self.get_custom_response(
            status.HTTP_400_BAD_REQUEST,
            None,
            'Booking not found or is not in pending status.'
        )

        Booking.objects.filter(id=pk).update(status=Booking.BookingStatus.CONFIRMED)
        booking.refresh_from_db() 
        serializer = BookingSerializer(booking)

        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Booking confirmed successfully.'
        )
    
@extend_schema(tags=['bookings'])
class CancelBookingView(CustomResponseMixin, UpdateAPIView):
    serializer_class = BookingStatusUpdateSerializer
    queryset = Booking.objects.all()

    def patch(self, request, pk):
        try:
            booking = Booking.objects.get(id=pk)
        except Booking.DoesNotExist:
            return self.get_custom_response(
            status.HTTP_400_BAD_REQUEST,
            None,
            'Booking not found or is not in pending status.'
        )

        if booking.status in [Booking.BookingStatus.COMPLETED, Booking.BookingStatus.CANCELLED]:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                'Booking cannot be canceled.'
            )
        
        booking.driverassignment_set.all().delete()
        Booking.objects.filter(id=pk).update(status=Booking.BookingStatus.CANCELLED)
        booking.refresh_from_db()
        serializer = BookingSerializer(booking)

        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Booking has been successfully canceled.'
        )