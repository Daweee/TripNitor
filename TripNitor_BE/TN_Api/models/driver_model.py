from django.db import models
from django.forms import ValidationError
from .user_model import User
from .base_model import CustomPrimaryKeyModel
from .van_model import Van

class Driver(CustomPrimaryKeyModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    van = models.ForeignKey(Van, on_delete=models.PROTECT, null=True, blank=True, related_name='assigned_drivers')
    license_number = models.CharField(max_length=20, unique=True)
    date_hired = models.DateField()

    def __str__(self):
        return f"Driver: {self.user.username} - Van: {self.van.plate_number}"

    def clean(self):
        super().clean()
        if not self.van:
            raise ValidationError({'van': 'Every driver must be assigned to a van.'})

    def save(self, *args, **kwargs):
        self.clean()
        super().save(*args, **kwargs)
        
    def is_available(self, start_date, end_date):
        from .booking_model import Booking
        
        return not self.bookings.filter(
            models.Q(start_date__lt=end_date, end_date__gt=start_date) |
            models.Q(start_date__range=(start_date, end_date)) |
            models.Q(end_date__range=(start_date, end_date)),
            status__in=[Booking.BookingStatus.CONFIRMED, Booking.BookingStatus.PENDING]
        ).exists()
    
    def delete(self, *args, **kwargs):
        from .driver_assignment_model import DriverAssignment  # Adjust import as needed
        if DriverAssignment.objects.filter(driver=self).exists():
            raise ValueError("Cannot delete driver with assigned bookings.")
        super().delete(*args, **kwargs)