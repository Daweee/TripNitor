from django.db import models
from .base_model import CustomPrimaryKeyModel

class Package(CustomPrimaryKeyModel):
    package_name = models.CharField(max_length=255)
    description = models.TextField()
    base_price = models.DecimalField(max_digits=10, decimal_places=2)
    duration = models.IntegerField()  # duration in days
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name