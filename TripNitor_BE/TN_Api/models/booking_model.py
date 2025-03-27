from decimal import Decimal
from random import shuffle
from django.db import models
from django.forms import ValidationError
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

    drivers = models.ManyToManyField('Driver', through='DriverAssignment', related_name='bookings')  # Use string reference
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

    def clean(self):
        if self.start_date >= self.end_date:
            raise ValidationError("End date must be after start date.")
        
        available_capacity = self.calculate_available_capacity()
        if self.number_of_passengers > available_capacity:
            raise ValidationError(f"Booking exceeds the available capacity and can't accommodate {self.number_of_passengers} passengers for the selected dates.")

    def save(self, *args, **kwargs):
        self.clean()
        self.calculate_number_of_nights()
        self.set_booking_start_and_final_locations()
        super().save(*args, **kwargs)

    def get_nights(self):
        return (self.end_date - self.start_date).days

    def calculate_final_fare(self, assigned_drivers):
        self.base_fare = 3000
        number_of_nights = self.get_nights()
        self.number_of_nights = number_of_nights

        self.updated_package_fare = self.calculate_gas_consumption_cost(assigned_drivers)
        self.total_price = self.updated_package_fare + self.base_fare + (number_of_nights * 1000)

    def calculate_gas_consumption_cost(self, assigned_drivers):
        total_distance = self.package.total_distance
        total_cost = Decimal('0.0')

        for driver in assigned_drivers:
            van = driver.van
            if van.gas:
                gas_price = van.gas.gas_price
                fuel_efficiency = 10
                cost = (gas_price / fuel_efficiency) * total_distance
                total_cost += cost

        return total_cost.quantize(Decimal('0.01'))

    def calculate_number_of_nights(self):
        self.base_fare = 3000
        number_of_nights = self.get_nights()
        self.number_of_nights = number_of_nights

    def get_available_drivers(self):
        from .driver_model import Driver 
        all_drivers = Driver.objects.all()
        available_drivers = []
        
        for driver in all_drivers:
            is_available = driver.is_available(self.start_date, self.end_date)
            if is_available:
                available_drivers.append(driver)
        
        return available_drivers
    
    def calculate_available_capacity(self):
        available_drivers = self.get_available_drivers()
        total_capacity = sum(driver.van.max_passengers for driver in available_drivers)
        return total_capacity

    def preview_driver_assignment(self):
        required_vans = (self.number_of_passengers + 14) // 15 
        available_drivers = list(self.get_available_drivers())
        shuffle(available_drivers)  

        return available_drivers[:required_vans]
    
    def set_booking_start_and_final_locations(self):
        package_instance = self.package
        self.start_location = package_instance.start_location
        self.final_destination = package_instance.final_destination

    def can_be_rated(self):
        return self.status == self.BookingStatus.COMPLETED and self.drivers.exists()
    
    def mark_as_rated(self):
        self.is_rated = True
        self.save()
        return self
    
    def set_booking_ratings(self, ratings):
        self.ratings = ratings
        self.save()
        return self