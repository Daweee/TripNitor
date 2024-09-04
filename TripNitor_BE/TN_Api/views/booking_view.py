from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.response import Response
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView,
    GenericAPIView
)
from ..serializers import BookingSerializer, BookingCreationSerializer
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
