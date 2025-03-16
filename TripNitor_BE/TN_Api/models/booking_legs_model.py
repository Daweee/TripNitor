from django.db import models
from ..models import Booking, Location

class BookingLeg(models.Model):
    booking = models.ForeignKey(Booking, related_name='booking_legs', on_delete=models.CASCADE)
    leg_number = models.PositiveIntegerField()
    start_location = models.ForeignKey(Location, related_name='booking_start_legs', on_delete=models.CASCADE)
    end_location = models.ForeignKey(Location, related_name='booking_end_legs', on_delete=models.CASCADE)
    departure_time = models.DateTimeField(null=True, blank=True) 
    arrival_time = models.DateTimeField(null=True, blank=True)
    original_leg_id = models.PositiveIntegerField(null=True, blank=True)  # For reference/analytics
    
    class Meta:
        ordering = ['leg_number']
        unique_together = ['booking', 'leg_number']

    def __str__(self):
        return f"Leg {self.leg_number} of Booking {self.booking.id}: {self.start_location.name} to {self.end_location.name}"