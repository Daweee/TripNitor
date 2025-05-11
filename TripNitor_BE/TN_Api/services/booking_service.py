from decimal import Decimal
from random import shuffle
from django.forms import ValidationError
from ..models import Booking

class BookingService:
    @staticmethod
    def validate_booking_dates(start_date, end_date):
        """Validate that end date is after start date."""
        if start_date >= end_date:
            raise ValidationError("End date must be after start date.")
    
    @staticmethod
    def get_available_drivers(booking):
        """Get all drivers available for the given booking dates."""
        from ..models.driver_model import Driver  # Import here to avoid circular imports
        all_drivers = Driver.objects.all()
        available_drivers = []
        
        for driver in all_drivers:
            if driver.is_available(booking.start_date, booking.end_date):
                available_drivers.append(driver)
        
        return available_drivers
    
    def assign_driver_for_joiner(start_date, end_date):
        """Get a single driver available for the given joiner package date."""
        from ..models.driver_model import Driver
        all_drivers = Driver.objects.all()

        available_drivers = []
        for driver in all_drivers:
            if driver.is_available(start_date, end_date):
                available_drivers.append(driver)
        
        shuffle(available_drivers)
        
        return available_drivers[0] if available_drivers else None
    
    @staticmethod
    def calculate_available_capacity(booking):
        """Calculate the total passenger capacity based on available drivers."""
        available_drivers = BookingService.get_available_drivers(booking)
        total_capacity = sum(driver.van.max_passengers for driver in available_drivers)
        return total_capacity
    
    @staticmethod
    def validate_capacity(booking):
        """Check if there's enough capacity for the number of passengers."""
        available_capacity = BookingService.calculate_available_capacity(booking)
        if booking.number_of_passengers > available_capacity:
            raise ValidationError(
                f"Booking exceeds the available capacity and can't accommodate "
                f"{booking.number_of_passengers} passengers for the selected dates."
            )
    
    @staticmethod
    def get_nights(start_date, end_date):
        """Calculate the number of nights between start and end date."""
        return (end_date - start_date).days
    
    @staticmethod
    def calculate_number_of_nights(booking):
        """Set the number of nights for the booking."""
        booking.number_of_nights = BookingService.get_nights(booking.start_date, booking.end_date)
        return booking.number_of_nights
    
    @staticmethod
    def preview_driver_assignment(booking):
        """Get a preview of drivers that would be assigned to the booking."""
        required_vans = (booking.number_of_passengers + 14) // 15 
        available_drivers = list(BookingService.get_available_drivers(booking))
        shuffle(available_drivers)  
        return available_drivers[:required_vans]
    
    @staticmethod
    def calculate_gas_consumption_cost(booking, assigned_drivers):
        """Calculate the gas consumption cost for the assigned drivers."""
        total_distance = booking.package.total_distance
        total_cost = Decimal('0.0')

        for driver in assigned_drivers:
            van = driver.van
            if van.gas:
                gas_price = van.gas.gas_price
                fuel_efficiency = 10
                cost = (gas_price / fuel_efficiency) * total_distance
                total_cost += cost

        return total_cost.quantize(Decimal('0.01'))
    
    @staticmethod
    def calculate_final_fare(booking, assigned_drivers):
        """Calculate the final fare for the booking."""
        BASE_FARE = Decimal('3000')
        NIGHTLY_RATE = Decimal('1000')
        
        number_of_nights = BookingService.get_nights(booking.start_date, booking.end_date)
        gas_cost = BookingService.calculate_gas_consumption_cost(booking, assigned_drivers)
        
        booking.base_fare = BASE_FARE
        booking.number_of_nights = number_of_nights
        booking.updated_package_fare = gas_cost
        booking.total_price = BASE_FARE + gas_cost + (number_of_nights * NIGHTLY_RATE)
        
        return booking.total_price
    
    @staticmethod
    def set_booking_locations(booking):
        """Set the start and final locations from the package."""
        package_instance = booking.package
        booking.start_location = package_instance.start_location
        booking.final_destination = package_instance.final_destination
    
    @staticmethod
    def can_be_rated(booking):
        """Check if the booking can be rated."""
        return booking.status == booking.BookingStatus.COMPLETED and booking.drivers.exists()
    
    @staticmethod
    def mark_as_rated(booking):
        """Mark the booking as rated."""
        booking.is_rated = True
        booking.save(update_fields=['is_rated'])
        return booking
    
    @staticmethod
    def set_booking_ratings(booking, ratings):
        """Set ratings for the booking."""
        booking.ratings = ratings
        booking.save(update_fields=['ratings'])
        return booking
    
    @staticmethod
    def check_user_booking_conflicts(user_id, start_date, end_date, exclude_booking_id=None):
        conflicting_bookings = Booking.objects.filter(
            user_id=user_id,
            start_date__lt=end_date,
            end_date__gt=start_date,
            status__in=[
                Booking.BookingStatus.PENDING,
                Booking.BookingStatus.CONFIRMED,
                Booking.BookingStatus.ONGOING
            ]
        )

        if exclude_booking_id:
            conflicting_bookings = conflicting_bookings.exclude(id=exclude_booking_id)
            
        if conflicting_bookings.exists():
            conflict = conflicting_bookings.first()
            
            conflict_start = conflict.start_date.strftime('%Y-%m-%d %H:%M')
            conflict_end = conflict.end_date.strftime('%Y-%m-%d %H:%M')
            
            package_info = ""
            if conflict.package:
                package_info = f" for package '{conflict.package.package_name}'"
            
            return True, f"You already have a booking{package_info} from {conflict_start} to {conflict_end}. Please select different dates."
            
        return False, None