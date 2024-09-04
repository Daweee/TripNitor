from django.db import models
from .booking_model import Booking
from .base_model import CustomPrimaryKeyModel
from .driver_model import Driver

class DriverAssignment(models.Model):
    driver = models.ForeignKey(Driver, on_delete=models.CASCADE)
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    assigned_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('driver', 'booking')

    def __str__(self):
        return f"{self.driver} assigned to {self.booking}" 