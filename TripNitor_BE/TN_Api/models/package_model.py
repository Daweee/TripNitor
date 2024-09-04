from django.db import models
from .base_model import CustomPrimaryKeyModel
from .location_model import Location

class Package(CustomPrimaryKeyModel):
    class PackageType(models.TextChoices):
        SOUTH = 'SOUTH', 'South'
        NORTH = 'NORTH', 'North'
        CITY = 'CITY', 'City'

    class PackageVisibility(models.TextChoices):
        PRIVATE = 'PRIVATE', 'Private'
        JOINER = 'JOINER', 'Joiner'
        
    package_name = models.CharField(max_length=255)
    description = models.TextField()
    base_price = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    package_type = models.CharField(max_length=5, choices=PackageType.choices)
    visibility = models.CharField(max_length=7, choices=PackageVisibility.choices, default=PackageVisibility.PRIVATE)
    start_location = models.ForeignKey(Location, related_name='package_starts', on_delete=models.SET_NULL, null=True, blank=True)
    final_destination = models.ForeignKey(Location, related_name='package_ends', on_delete=models.SET_NULL, null=True, blank=True)
    max_participants = models.PositiveIntegerField(null=True, blank=True)  # For JOINER packages
    current_participants = models.PositiveIntegerField(null=True, blank=True)  # For JOINER packages
    start_date = models.DateTimeField(null=True, blank=True)  # For scheduling for JOINER packages
    end_date = models.DateTimeField(null=True, blank=True)  # For scheduling for JOINER packages

    def __str__(self):
        return self.package_name

    def save(self, *args, **kwargs):
        # if self.visibility == self.PackageVisibility.PRIVATE:
        #     self.max_participants = self.capacity
        self.clean()
        super().save(*args, **kwargs)

        