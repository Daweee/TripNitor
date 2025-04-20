from django.db import models
from .base_model import CustomPrimaryKeyModel
from .location_model import Location
from .driver_model import Driver
from django.core.exceptions import ValidationError
from django.db.models import Min

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
    total_distance = models.DecimalField(max_digits=10, decimal_places=2, default=None, help_text="Total distance in kilometers")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    package_type = models.CharField(max_length=5, choices=PackageType.choices)
    visibility = models.CharField(max_length=7, choices=PackageVisibility.choices, default=PackageVisibility.PRIVATE)
    start_location = models.ForeignKey(Location, related_name='package_starts', on_delete=models.SET_NULL, null=True, blank=True)
    final_destination = models.ForeignKey(Location, related_name='package_ends', on_delete=models.SET_NULL, null=True, blank=True)
    max_participants = models.PositiveIntegerField(default=15, null=True, blank=True)  # For JOINER packages
    current_participants = models.PositiveIntegerField(null=True, blank=True)  # For JOINER packages
    assigned_driver = models.ForeignKey(Driver, related_name='assigned_driver', on_delete=models.CASCADE, null=True, blank=True) # For JOINER packages
    start_date = models.DateTimeField(null=True, blank=True)  # For scheduling for JOINER packages
    end_date = models.DateTimeField(null=True, blank=True)  # For scheduling for JOINER packages

    def __str__(self):
        return self.package_name

    def clean(self):
        """Validate package data before saving."""
        super().clean()
        if self.visibility == self.PackageVisibility.JOINER:
            if not self.max_participants:
                raise ValidationError("Max participants is required for joiner packages")
            if self.max_participants > 15:
                raise ValidationError("Max participants cannot exceed 15")
            if not self.start_date or not self.end_date:
                raise ValidationError("Start and end dates are required for joiner packages")
            if self.start_date >= self.end_date:
                raise ValidationError("End date must be after start date")
            if self.current_participants and self.current_participants > self.max_participants:
                raise ValidationError("Current participants cannot exceed max participants")
        
        if not self.start_location or not self.final_destination:
            raise ValidationError("Start location and final destination are required")
        
        if self.total_distance is not None and self.total_distance <= 0:
            raise ValidationError("Total distance must be greater than 0")

    def save(self, *args, **kwargs):
        """Save package with validation."""
        self.clean()
        super().save(*args, **kwargs)
