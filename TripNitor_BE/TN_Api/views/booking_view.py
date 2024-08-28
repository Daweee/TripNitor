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

class BookingCreateView(CreateAPIView):
    serializer_class = BookingSerializer
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            booking = serializer.save()
            response_data = {
                'status': status.HTTP_201_CREATED,
                'data': {'booking': serializer.data},
                'message': 'Booking created successfully'
            }
            return Response(response_data, status=status.HTTP_201_CREATED)
        except IntegrityError as e:
            response_data = {
                'status': status.HTTP_400_BAD_REQUEST,
                'data': None,
                'message': 'A booking with this ID already exists.'
            }
            return Response(response_data, status=status.HTTP_400_BAD_REQUEST)


class BookingListView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BookingSerializer
    queryset = Booking.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'bookings': serializer.data},
            'message': 'Booking list retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)


class BookingDetailView(RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BookingSerializer
    queryset = Booking.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'booking': serializer.data},
            'message': 'Booking details retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)


class BookingUpdateView(UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BookingSerializer
    queryset = Booking.objects.all()

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        booking = serializer.save()
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'booking': serializer.data},
            'message': 'Booking details updated successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)


class BookingDeleteView(DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        response_data = {
            'status': status.HTTP_204_NO_CONTENT,
            'data': None,
            'message': 'Booking deleted successfully'
        }
        return Response(response_data, status=status.HTTP_204_NO_CONTENT)
    
    