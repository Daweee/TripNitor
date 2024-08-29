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
from ..serializers import BookingSerializer
from TN_Api.models import Booking
from django.db import IntegrityError
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin

@extend_schema(tags=['bookings'])
class BookingCreateView(CustomResponseMixin, CreateAPIView):
    serializer_class = BookingSerializer
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            booking = serializer.save()
            booking.assign_drivers()  # Call the assign_drivers method
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                {'booking': serializer.data},
                'Booking created successfully'
            )
        except IntegrityError as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                'A booking with this ID already exists.'
            )
    # def post(self, request, *args, **kwargs):
    #     serializer = self.get_serializer(data=request.data)
    #     serializer.is_valid(raise_exception=True)
    #     try:
    #         booking = serializer.save()
    #         response_data = {
    #             'status': status.HTTP_201_CREATED,
    #             'data': {'booking': serializer.data},
    #             'message': 'Booking created successfully'
    #         }
    #         return Response(response_data, status=status.HTTP_201_CREATED)
    #     except IntegrityError as e:
    #         response_data = {
    #             'status': status.HTTP_400_BAD_REQUEST,
    #             'data': None,
    #             'message': 'A booking with this ID already exists.'
    #         }
    #         return Response(response_data, status=status.HTTP_400_BAD_REQUEST)
    
    # def perform_create(self, serializer):
    #     booking = serializer.save()
    #     booking.assign_drivers()
    #     return booking

@extend_schema(tags=['bookings'])
class BookingListView(CustomResponseMixin, ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BookingSerializer

    def get_queryset(self):
        user = self.request.user
        if user.is_staff:
            return Booking.objects.all()
        return Booking.objects.filter(user=user)
    
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        return self.get_custom_response(
            status.HTTP_200_OK,
            {'bookings': serializer.data},
            'Booking list retrieved successfully'
        )

@extend_schema(tags=['bookings'])
class BookingDetailView(CustomResponseMixin, RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BookingSerializer
    queryset = Booking.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        return self.get_custom_response(
            status.HTTP_200_OK,
            {'booking': serializer.data},
            'Booking details retrieved successfully'
        )

@extend_schema(tags=['bookings'])
class BookingUpdateView(CustomResponseMixin, UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BookingSerializer
    queryset = Booking.objects.all()

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()

        # Check if the user has permission to update this booking
        # if not request.user.is_staff and instance.user != request.user:
        #     raise PermissionDenied("You don't have permission to update this booking.")

        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        try:
            booking = serializer.save()
            
            # If the number of passengers has changed, reassign drivers
            if 'number_of_passengers' in serializer.validated_data:
                booking.driver_bookings.all().delete()  # Clear existing assignments
                booking.assign_drivers()  # Reassign drivers
            
            return self.get_custom_response(
                status.HTTP_200_OK,
                {'booking': serializer.data},
                'Booking updated successfully'
            )
        except Exception as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                str(e)
            )

@extend_schema(tags=['bookings'])
class BookingDeleteView(CustomResponseMixin, DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()

        # Check if the user has permission to delete this booking
        # if not request.user.is_staff and instance.user != request.user:
        #     raise PermissionDenied("You don't have permission to delete this booking.")
        
        try:
            self.perform_destroy(instance)
            return self.get_custom_response(
                status.HTTP_204_NO_CONTENT,
                None,
                'Booking deleted successfully'
            )
        except Exception as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                str(e)
            )
    
    