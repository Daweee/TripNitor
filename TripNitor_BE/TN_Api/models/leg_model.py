from django.db import models
from django.forms import ValidationError
from TN_Api.models import Package, Location

class Leg(models.Model):
    package = models.ForeignKey(Package, on_delete=models.CASCADE, related_name='legs')
    leg_number = models.PositiveIntegerField()
    start_location = models.ForeignKey(Location, related_name='start_legs', on_delete=models.CASCADE)
    end_location = models.ForeignKey(Location, related_name='end_legs', on_delete=models.CASCADE)
    departure_time = models.DateTimeField(null=True, blank=True) 
    arrival_time = models.DateTimeField(null=True, blank=True)    

    class Meta:
        ordering = ['leg_number']  # Ensure legs are always in order
        unique_together = ['package', 'leg_number']  # Ensure unique leg numbers per package

    def clean(self):
        if self.departure_time and self.arrival_time and self.departure_time >= self.arrival_time:
            raise ValidationError("Departure time must be before arrival time.")

    def save(self, *args, **kwargs):
        self.clean()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"Leg {self.leg_number} of Package {self.package.package_name}: {self.start_location.name} to {self.end_location.name}"