from django.db import models
from .gas_model import Gas

class Van(models.Model):
    model = models.CharField(max_length=100)
    plate_number = models.CharField(max_length=15, unique=True)
    date_bought = models.DateField()
    registration_expiry_date = models.DateField()
    max_passengers = models.IntegerField()
    gas = models.ForeignKey(Gas, on_delete=models.SET_NULL, null=True, blank=True)

    def __str__(self):
        return f"{self.model} ({self.plate_number})"