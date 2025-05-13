from django.db import models
from .user_model import User
from .package_model import Package

class PackageUser(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='package_users')
    package = models.ForeignKey(Package, on_delete=models.CASCADE, related_name='package_users')
    number_of_passengers = models.PositiveIntegerField(null=True, blank=False)
    joined_at = models.DateTimeField(auto_now_add=True)
    booking = models.ForeignKey('Booking', on_delete=models.SET_NULL, null=True, blank=True)

    class Meta:
        unique_together = ('user', 'package')
        
    def __str__(self):
        return f"{self.user.username} - {self.package.package_name}"