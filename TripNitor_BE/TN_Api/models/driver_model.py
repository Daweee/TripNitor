from django.db import models
from .user_model import User

class Driver(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    license_number = models.CharField(max_length=20, unique=True)
    date_hired = models.DateField()

    def __str__(self):
        return f"Driver: {self.user.username}"