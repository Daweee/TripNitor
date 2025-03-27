from ..models import Rating, Booking, Driver
from rest_framework.exceptions import ValidationError, PermissionDenied
from django.db import transaction

class RatingService:
    
    def validate_can_rate(self, booking, user):
        if not booking.can_be_rated():
            raise ValidationError(
                "Only completed bookings with assigned drivers can be rated"
            )
        
        if user != booking.user:
            raise PermissionDenied(
                "Only the booking customer can rate their booking"
            )
        
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

            booking.set_booking_ratings(int(rating))
            booking.mark_as_rated()

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