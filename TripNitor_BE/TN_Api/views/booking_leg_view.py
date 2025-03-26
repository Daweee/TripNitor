from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.generics import (
    UpdateAPIView,
)
from rest_framework import status
from drf_spectacular.utils import extend_schema
from django.utils import timezone
from .mixins import CustomResponseMixin
from ..serializers import BookingLegStatusUpdateSerializer, BookingLegSerializer
from ..models import BookingLeg

@extend_schema(tags=['booking legs'])
class SetBookingLegActiveView(CustomResponseMixin, UpdateAPIView):
    serializer_class = BookingLegStatusUpdateSerializer
    queryset = BookingLeg.objects.all()

    def patch(self, request, pk):
        try:
            booking_leg = BookingLeg.objects.get(id=pk)
        except BookingLeg.DoesNotExist:
            return self.get_custom_response(
                status.HTTP_404_NOT_FOUND,
                None,
                'Booking leg not found.'
            )
        
        if booking_leg.booking.status != 'ONGOING':
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                f'Cannot update booking leg when booking status is {booking_leg.booking.status}. Booking must be ONGOING.'
            )
            
        if booking_leg.is_active:
            serializer = BookingLegSerializer(booking_leg)
            return self.get_custom_response(
                status.HTTP_200_OK,
                serializer.data,
                'Booking leg is already active.'
            )
            
        if booking_leg.is_completed:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                'Cannot activate a booking leg that has already been completed.'
            )
            
        if booking_leg.leg_number > 1:
            try:
                previous_leg = BookingLeg.objects.get(
                    booking=booking_leg.booking,
                    leg_number=booking_leg.leg_number - 1
                )
                
                if not previous_leg.is_completed:
                    return self.get_custom_response(
                        status.HTTP_400_BAD_REQUEST,
                        None,
                        f'Cannot activate leg {booking_leg.leg_number} because the previous leg {previous_leg.leg_number} has not been completed.'
                    )
            except BookingLeg.DoesNotExist:
                return self.get_custom_response(
                    status.HTTP_400_BAD_REQUEST,
                    None,
                    f'Previous leg {booking_leg.leg_number - 1} not found. Cannot establish proper sequence.'
                )
        
        booking = booking_leg.booking
        BookingLeg.objects.filter(booking=booking, is_active=True).update(is_active=False)
        
        booking_leg.is_active = True
        booking_leg.departure_time = timezone.now()
        booking_leg.save()
        
        serializer = BookingLegSerializer(booking_leg)
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Booking leg set to active successfully.'
        )
    
@extend_schema(tags=['booking legs'])
class CompleteBookingLegView(CustomResponseMixin, UpdateAPIView):
    serializer_class = BookingLegStatusUpdateSerializer
    queryset = BookingLeg.objects.all()

    def patch(self, request, pk):
        try:
            booking_leg = BookingLeg.objects.get(id=pk)
        except BookingLeg.DoesNotExist:
            return self.get_custom_response(
                status.HTTP_404_NOT_FOUND,
                None,
                'Booking leg not found.'
            )
        
        if booking_leg.booking.status != 'ONGOING':
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                f'Cannot complete booking leg when booking status is {booking_leg.booking.status}. Booking must be ONGOING.'
            )
            
        if booking_leg.is_completed:
            serializer = BookingLegSerializer(booking_leg)
            return self.get_custom_response(
                status.HTTP_200_OK,
                serializer.data,
                'Booking leg is already completed.'
            )
            
        if not booking_leg.is_active:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                'Only active booking legs can be completed.'
            )
        
        booking_leg.is_completed = True
        booking_leg.is_active = False
        booking_leg.arrival_time = timezone.now()
        booking_leg.save()
        
        is_last_leg = not BookingLeg.objects.filter(
            booking=booking_leg.booking,
            leg_number__gt=booking_leg.leg_number
        ).exists()
        
        if is_last_leg:
            booking = booking_leg.booking
            booking.status = 'COMPLETED'
            booking.save()
        
        serializer = BookingLegSerializer(booking_leg)
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Booking leg marked as completed successfully.'
        )