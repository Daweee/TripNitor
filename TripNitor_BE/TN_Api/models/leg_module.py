from django.db import models
from TN_Api.models import Package, Location

class Leg(models.Model):
    package = models.ForeignKey(Package, on_delete=models.CASCADE, related_name='legs')
    leg_number = models.PositiveIntegerField()
    start_location = models.ForeignKey(Location, related_name='start_legs', on_delete=models.CASCADE)
    end_location = models.ForeignKey(Location, related_name='end_legs', on_delete=models.CASCADE)
    departure_time = models.DateTimeField()
    arrival_time = models.DateTimeField()

    def __str__(self):
        return f"Leg {self.leg_number} of Package {self.package.package_name}"