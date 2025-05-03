from decimal import Decimal
from django.db import models
from .base_model import CustomPrimaryKeyModel
from ..models import Package, User
from .location_model import Location
from django.db.models import Q

class Booking(CustomPrimaryKeyModel):
    class BookingStatus(models.TextChoices):
        PENDING = 'PENDING', 'Pending'
        CONFIRMED = 'CONFIRMED', 'Confirmed'
        ONGOING = 'ONGOING', 'Ongoing'
        CANCELLED = 'CANCELLED', 'Cancelled'
        COMPLETED = 'COMPLETED', 'Completed'

    class PaymentMode(models.TextChoices):
        CASH = 'CASH', 'Cash'
        CREDIT_CARD = 'CREDIT_CARD', 'Credit Card'

    drivers = models.ManyToManyField('Driver', through='DriverAssignment', related_name='bookings')
    package = models.ForeignKey(Package, related_name='bookings', on_delete=models.CASCADE)
    start_location = models.ForeignKey(Location, related_name='booking_starting_location', on_delete=models.SET_NULL, null=True, blank=True)
    final_destination = models.ForeignKey(Location, related_name='booking_final_location', on_delete=models.SET_NULL, null=True, blank=True)
    user = models.ForeignKey('User', related_name='bookings', on_delete=models.CASCADE)
    status = models.CharField(max_length=20, choices=BookingStatus.choices, default=BookingStatus.PENDING)
    base_fare = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    updated_package_fare = models.DecimalField(max_digits=10, decimal_places=2)
    number_of_nights = models.PositiveIntegerField(null=True, blank=True)
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    number_of_passengers = models.PositiveIntegerField()
    mode_of_payment = models.CharField(max_length=20, choices=PaymentMode.choices, default=PaymentMode.CASH)
    is_rated = models.BooleanField(default=False)
    ratings = models.PositiveIntegerField(null=True, blank=True)  
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()

    def __str__(self):
        return f"Booking by {self.user.username} for {self.package.package_name}"