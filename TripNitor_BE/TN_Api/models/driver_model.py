from django.db import models
from django.forms import ValidationError
from .user_model import User
from .base_model import CustomPrimaryKeyModel
from .van_model import Van

class Driver(CustomPrimaryKeyModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    van = models.OneToOneField(Van, on_delete=models.PROTECT)
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
        return not self.driverassignment_set.filter(
            models.Q(booking__start_date__lte=end_date, booking__end_date__gte=start_date),
            booking__status__in=[Booking.BookingStatus.CONFIRMED, Booking.BookingStatus.PENDING]
        ).exists()