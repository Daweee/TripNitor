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
from ..serializers import BookingSerializer, BookingCreationSerializer, BookingPreviewSerializer
from ..models import Booking
from django.db import IntegrityError
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin

@extend_schema(tags=['bookings'])
class BookingListView(CustomResponseMixin, ListAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK, 
            {'bookings': serializer.data}, 
            'Bookings retrieved successfully.'
        )

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
                {'booking': serializer.data},
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
             {'booking': serializer.data}, 
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

            available_drivers = temp_booking.get_available_drivers()
            required_vans = (number_of_passengers + 14) // 15
            assigned_drivers = available_drivers[:required_vans]
            temp_booking.calculate_final_fare()
            total_price = temp_booking.total_price

            preview_data = {
                'package': package.package_name,
                'start_date': start_date,
                'end_date': end_date,
                'number_of_passengers': number_of_passengers,
                'base_fare': package.base_price,
                'total_price': total_price,
                'assigned_drivers': [
                    {
                        'name': driver.user.name,
                        'van_model': driver.van.model,
                        'van_plate_number': driver.van.plate_number,
                    } for driver in assigned_drivers
                ]
            }
            return Response({
                'status': status.HTTP_200_OK,
                'data': {'booking_preview': preview_data},
                'message': 'Booking preview generated successfully.'
            })
        else:
            return Response({
                'status': status.HTTP_400_BAD_REQUEST,
                'data': serializer.errors,
                'message': 'Invalid data provided for booking preview.'
            }, status=status.HTTP_400_BAD_REQUEST)