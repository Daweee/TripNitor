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
        
    @staticmethod
    def swap_driver(booking_id, old_driver_id, new_driver_id):
        if not all([booking_id, old_driver_id, new_driver_id]):
            return None, "booking_id, old_driver_id, and new_driver_id are required"
            
        try:
            with transaction.atomic():
                booking = Booking.objects.get(id=booking_id, status=Booking.BookingStatus.PENDING)
                
                assignment = DriverAssignment.objects.get(
                    booking_id=booking_id,
                    driver_id=old_driver_id
                )
                
                conflicts = DriverAssignment.objects.filter(
                    driver_id=new_driver_id,
                    start_date__lt=assignment.end_date,
                    end_date__gt=assignment.start_date
                ).exclude(booking_id=booking_id).exists()
                
                if conflicts:
                    return None, "Selected driver has conflicting assignments"

                new_driver = Driver.objects.get(id=new_driver_id, user__is_active=True)

                assignment.driver = new_driver
                assignment.assigned_at = timezone.now()
                assignment.save()
                
                return assignment, None
                
        except Booking.DoesNotExist:
            return None, "Booking not found or not in PENDING status"
        except DriverAssignment.DoesNotExist:
            return None, "Assignment not found for the specified driver and booking"
        except Driver.DoesNotExist:
            return None, "New driver not found or inactive"
        except Exception as e:
            return None, str(e)