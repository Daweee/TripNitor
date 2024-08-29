from django.db import models
from .base_model import CustomPrimaryKeyModel

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
    # duration = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    package_type = models.CharField(max_length=5, choices=PackageType.choices)
    visibility = models.CharField(max_length=7, choices=PackageVisibility.choices)

    def __str__(self):
        return self.name