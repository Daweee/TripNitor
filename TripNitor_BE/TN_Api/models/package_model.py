from django.db import models
from .base_model import CustomPrimaryKeyModel
from .location_model import Location
from .gas_model import Gas
from decimal import Decimal
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
    max_participants = models.PositiveIntegerField(null=True, blank=True)  # For JOINER packages
    current_participants = models.PositiveIntegerField(null=True, blank=True)  # For JOINER packages
    start_date = models.DateTimeField(null=True, blank=True)  # For scheduling for JOINER packages
    end_date = models.DateTimeField(null=True, blank=True)  # For scheduling for JOINER packages

    def __str__(self):
        return self.package_name

    def calculate_base_price(self):
        lowest_gas_price = Gas.objects.aggregate(Min('gas_price'))['gas_price__min']
        if lowest_gas_price is not None:
            price_per_km = Decimal(lowest_gas_price) / Decimal('10')
            distance_cost = price_per_km * self.total_distance
            return distance_cost.quantize(Decimal('0.01'))
        return Decimal('0') 

    def save(self, *args, **kwargs):
        # if self.visibility == self.PackageVisibility.PRIVATE:
        #     self.max_participants = self.capacity

        if not self.pk or not self.base_price:  
            self.base_price = self.calculate_base_price()

        self.clean()
        super().save(*args, **kwargs)

        