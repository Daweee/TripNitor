from django.db import models

class Gas(models.Model):
    gas_name = models.CharField(max_length=50, unique=True)
    gas_price = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.gas_name