from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.generics import (
    UpdateAPIView,
)
from rest_framework import status
from drf_spectacular.utils import extend_schema
from django.utils import timezone
from .mixins import CustomResponseMixin
from ..serializers import BookingLegStatusUpdateSerializer, BookingLegSerializer
from ..models import BookingLeg, Package
from django.db import transaction

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
        
        with transaction.atomic():
            booking = booking_leg.booking
            package = booking.package

            BookingLeg.objects.filter(booking=booking, is_active=True).update(is_active=False)

            if package.visibility == Package.PackageVisibility.JOINER:
                same_package_bookings = booking.__class__.objects.filter(
                    package=package,
                    status='ONGOING'
                ).exclude(id=booking.id)
                
                BookingLeg.objects.filter(
                    booking__in=same_package_bookings,
                    is_active=True
                ).update(is_active=False)
                
                same_leg_number_legs = BookingLeg.objects.filter(
                    booking__in=same_package_bookings,
                    leg_number=booking_leg.leg_number,
                    is_completed=False 
                )
                
                current_time = timezone.now()
                same_leg_number_legs.update(is_active=True, departure_time=current_time)
            
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
        
        with transaction.atomic():
            booking = booking_leg.booking
            package = booking.package
            
            booking_leg.is_completed = True
            booking_leg.is_active = False
            booking_leg.arrival_time = timezone.now()
            booking_leg.save()

            same_package_bookings = []
            if package.visibility == Package.PackageVisibility.JOINER:
                same_package_bookings = booking.__class__.objects.filter(
                    package=package,
                    status='ONGOING'
                ).exclude(id=booking.id)
                
                current_time = timezone.now()
                BookingLeg.objects.filter(
                    booking__in=same_package_bookings,
                    leg_number=booking_leg.leg_number,
                    is_active=True
                ).update(is_completed=True, is_active=False, arrival_time=current_time)
            
            is_last_leg = not BookingLeg.objects.filter(
                booking=booking,
                leg_number__gt=booking_leg.leg_number
            ).exists()
            
            if is_last_leg:
                booking.status = 'COMPLETED'
                booking.save()
                
                if package.visibility == Package.PackageVisibility.JOINER:
                    all_completed = True
                    
                    for other_booking in same_package_bookings:
                        other_is_last_leg = not BookingLeg.objects.filter(
                            booking=other_booking,
                            leg_number__gt=booking_leg.leg_number
                        ).exists()
                        
                        if other_is_last_leg:
                            other_booking.status = 'COMPLETED'
                            other_booking.save()
                    
                    incomplete_bookings = booking.__class__.objects.filter(
                        package=package
                    ).exclude(
                        status='COMPLETED'
                    ).exclude(
                        status='CANCELLED'
                    ).exists()
                    
                    if not incomplete_bookings:
                        package.is_completed = True
                        package.save()
        
        serializer = BookingLegSerializer(booking_leg)
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Booking leg marked as completed successfully.'
        )