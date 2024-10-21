from django.db import models
from .booking_model import Booking
from .base_model import CustomPrimaryKeyModel
from .driver_model import Driver

class DriverAssignment(models.Model):
    driver = models.ForeignKey(Driver, on_delete=models.CASCADE)
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    assigned_at = models.DateTimeField(auto_now_add=True)
    start_date = models.DateTimeField(null=True)
    end_date = models.DateTimeField(null=True)

    class Meta:
        unique_together = ('driver', 'booking')

    def __str__(self):
        return f"{self.driver} assigned to {self.booking}" 
    
    def save(self, *args, **kwargs):
        if not self.start_date or not self.end_date:
            self.start_date = self.booking.start_date
            self.end_date = self.booking.end_date
        super().save(*args, **kwargs)