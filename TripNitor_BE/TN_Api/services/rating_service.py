from ..models import Rating, Booking, Driver
from rest_framework.exceptions import ValidationError, PermissionDenied
from django.db import transaction

class RatingService:
    
    def validate_can_rate(self, booking, user):
        if booking.status != Booking.BookingStatus.COMPLETED:
            raise ValidationError(
                "Only completed bookings with assigned drivers can be rated"
            )
        
        if user != booking.user:
            raise PermissionDenied(
                "Only the booking customer can rate their booking"
            )
                
    def set_booking_ratings(self, booking, rating_value):
        booking.ratings = rating_value
        booking.is_rated = True
        booking.save(update_fields=['ratings', 'is_rated'])

    def create_rating(self, booking_id, user, rating, comment=""):
        try:
            booking = Booking.objects.get(id=booking_id)
        except Booking.DoesNotExist:
            raise ValidationError("Booking not found")
        
        self.validate_can_rate(booking, user)
        self._validate_rating_value(rating, "rating")

        with transaction.atomic():
            rating_obj, created = Rating.objects.update_or_create(
                booking=booking,
                user=user,
                defaults={
                    'rating': int(rating),
                    'comment': comment
                }
            )

            self.set_booking_ratings(booking, int(rating))

        return rating_obj

    def _validate_rating_value(self, rating, field_name):
        try:
            rating_value = int(rating)
            if not (0 <= rating_value <= 5):
                raise ValidationError(
                    "Rating must be between 0 and 5"
                )
        except (ValueError, TypeError):
            raise ValidationError(
               "Rating must be an integer"
            )
