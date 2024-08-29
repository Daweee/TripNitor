from django.db import models
from .booking_model import Booking
from .base_model import CustomPrimaryKeyModel
from .driver_model import Driver

class DriverBooking(CustomPrimaryKeyModel):
    booking = models.ForeignKey(Booking, related_name='driver_bookings', on_delete=models.CASCADE)
    driver = models.ForeignKey(Driver, related_name='bookings', on_delete=models.CASCADE)
    passengers = models.IntegerField()

    def __str__(self):
        return f"Driver: {self.driver.user.username} for Booking: {self.booking.id}"    