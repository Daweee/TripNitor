from django.db import models
from .gas_model import Gas
from django.core.exceptions import ValidationError
from .base_model import CustomPrimaryKeyModel

class Van(CustomPrimaryKeyModel):
    model = models.CharField(max_length=100)
    plate_number = models.CharField(max_length=15, unique=True)
    date_bought = models.DateField()
    registration_expiry_date = models.DateField()
    max_passengers = models.IntegerField()
    gas = models.ForeignKey(Gas, on_delete=models.PROTECT, null=True, blank=True)

    def clean(self):
        if not (1 <= self.max_passengers <= 15):
            raise ValidationError({'max_passengers': 'Max passengers must be between 1 and 15.'})

    def save(self, *args, **kwargs):
        self.clean()  # Ensure validation is called before saving
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.model} ({self.plate_number})"