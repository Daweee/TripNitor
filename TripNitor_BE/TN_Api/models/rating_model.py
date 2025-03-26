from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from TN_Api.models import Booking, User

class Rating(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='ratings')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='booking_ratings')
    rating = models.IntegerField(
        help_text="Rating from 0 to 5 stars"
    )
    comment = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('booking', 'user')

    def __str__(self):
        return f"{self.user.username}'s rating for Booking #{self.booking.booking_number}: {self.rating} stars"
    
