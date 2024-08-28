from django.db import models
from .base_model import CustomPrimaryKeyModel
from .package_model import Package
from .user_model import User

class Booking(CustomPrimaryKeyModel):
    user = models.ForeignKey(User, related_name='bookings', on_delete=models.CASCADE)
    package = models.ForeignKey(Package, related_name='bookings', on_delete=models.CASCADE)
    booking_date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=[('Pending', 'Pending'), ('Confirmed', 'Confirmed'), ('Cancelled', 'Cancelled')])
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Booking by {self.user.username} for {self.package.name}"