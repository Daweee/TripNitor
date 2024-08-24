from django.db import models
from .user_model import User
from .base_model import CustomPrimaryKeyModel

class Driver(CustomPrimaryKeyModel):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    license_number = models.CharField(max_length=20, unique=True)
    date_hired = models.DateField()

    def __str__(self):
        return f"Driver: {self.user.username}"