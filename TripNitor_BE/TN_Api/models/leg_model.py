from django.db import models
from django.forms import ValidationError
from TN_Api.models import Package, Location

class Leg(models.Model):
    package = models.ForeignKey(Package, on_delete=models.CASCADE, related_name='legs')
    leg_number = models.PositiveIntegerField()
    start_location = models.ForeignKey(Location, related_name='start_legs', on_delete=models.CASCADE)
    end_location = models.ForeignKey(Location, related_name='end_legs', on_delete=models.CASCADE)   

    class Meta:
        ordering = ['leg_number']  # Ensure legs are always in order
        unique_together = ['package', 'leg_number']  # Ensure unique leg numbers per package

    def save(self, *args, **kwargs):
        self.clean()
        super().save(*args, **kwargs)

        def __str__(self):
            return f"Leg {self.leg_number} of booking {self.booking.id}: {self.start_location.name} to {self.end_location.name}"