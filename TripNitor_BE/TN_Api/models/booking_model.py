from django.db import models
from django.forms import ValidationError
from .base_model import CustomPrimaryKeyModel
from .package_model import Package
from .user_model import User

class Booking(CustomPrimaryKeyModel):
    class BookingStatus(models.TextChoices):
        PENDING = 'PENDING', 'Pending'
        CONFIRMED = 'CONFIRMED', 'Confirmed'
        CANCELLED = 'CANCELLED', 'Cancelled'
        COMPLETED = 'COMPLETED', 'Completed'

    class PaymentMode(models.TextChoices):
        CASH = 'CASH', 'Cash'
        CREDIT_CARD = 'CREDIT_CARD', 'Credit Card'
        BANK_TRANSFER = 'BANK_TRANSFER', 'Bank Transfer'
        ONLINE_PAYMENT = 'ONLINE_PAYMENT', 'Online Payment'

    user = models.ForeignKey(User, related_name='bookings', on_delete=models.CASCADE)
    package = models.ForeignKey(Package, related_name='bookings', on_delete=models.CASCADE)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    status = models.CharField(max_length=20, choices=[('Pending', 'Pending'), ('Confirmed', 'Confirmed'), ('Cancelled', 'Cancelled')])
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    number_of_passengers = models.IntegerField()
    mode_of_payment = models.CharField(max_length=20, choices=PaymentMode.choices, default=PaymentMode.CASH)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Booking by {self.user.username} for {self.package.package_name}"
    
    def save(self, *args, **kwargs):
        if not self.pk:  # Only run this logic when creating a new booking
            self.assign_drivers()
        super().save(*args, **kwargs)

    def assign_drivers(self):
        from .driver_model import Driver
        from .driver_booking_model import DriverBooking

        num_vans_needed = (self.number_of_passengers - 1) // 15 + 1
        available_drivers = [
            driver for driver in Driver.objects.all()
            if driver.is_available(self.start_date, self.end_date)
        ]

        if len(available_drivers) < num_vans_needed:
            raise ValidationError("Not enough available drivers for this booking.")

        for i in range(num_vans_needed):
            DriverBooking.objects.create(
                booking=self,
                driver=available_drivers[i],
                passengers=(15 if i < num_vans_needed - 1 
                            else self.number_of_passengers - (num_vans_needed - 1) * 15)
            )
    
