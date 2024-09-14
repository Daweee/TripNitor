from django.db import models
from django.forms import ValidationError
from .base_model import CustomPrimaryKeyModel
from .package_model import Package
from .user_model import User

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
    user = models.ForeignKey('User', related_name='bookings', on_delete=models.CASCADE)
    status = models.CharField(max_length=20, choices=BookingStatus.choices, default=BookingStatus.PENDING)
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    number_of_passengers = models.PositiveIntegerField()
    mode_of_payment = models.CharField(max_length=20, choices=PaymentMode.choices, default=PaymentMode.CASH)
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
        self.calculate_final_fare()
        
        super().save(*args, **kwargs)
        if self.status == self.BookingStatus.PENDING:
            self.assign_drivers()

    def calculate_final_fare(self):
        self.total_price = self.package.base_price * 2

    def assign_drivers(self):
        from .driver_assignment_model import DriverAssignment
        required_vans = (self.number_of_passengers + 14) // 15 
        available_drivers = self.get_available_drivers()

        assigned_drivers = []
        for driver in available_drivers[:required_vans]:
            DriverAssignment.objects.create(driver=driver, booking=self)
            assigned_drivers.append(driver)
        
        return assigned_drivers
    
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