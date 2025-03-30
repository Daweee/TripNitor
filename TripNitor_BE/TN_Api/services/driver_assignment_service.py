from ..models import Driver, DriverAssignment, Booking
from django.db import transaction
from django.utils import timezone
from datetime import datetime

class DriverAssignmentService:
    @staticmethod
    def get_available_drivers_for_swap(booking_id, start_date, end_date):
        try:
            if isinstance(start_date, str):
                start_date = datetime.fromisoformat(start_date.replace('Z', ''))
            if isinstance(end_date, str):
                end_date = datetime.fromisoformat(end_date.replace('Z', ''))
            
            if timezone.is_naive(start_date):
                start_date = timezone.make_aware(start_date)
            if timezone.is_naive(end_date):
                end_date = timezone.make_aware(end_date)
         
            booking = Booking.objects.filter(id=booking_id, status=Booking.BookingStatus.PENDING).first()
            if not booking:
                return None, "Booking not found or not in PENDING status"
                
            assigned_driver_ids = DriverAssignment.objects.filter(
                booking_id=booking_id
            ).values_list('driver_id', flat=True)
            
            busy_driver_ids = DriverAssignment.objects.filter(
                start_date__lt=end_date,
                end_date__gt=start_date
            ).exclude(
                booking_id=booking_id
            ).values_list('driver_id', flat=True).distinct()

            available_drivers = Driver.objects.filter(
                user__is_active=True
            ).exclude(
                id__in=assigned_driver_ids  
            ).exclude(
                id__in=busy_driver_ids      
            ).order_by('id')
            
            return available_drivers, None
            
        except Exception as e:
            return None, str(e)