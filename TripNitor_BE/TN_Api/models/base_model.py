import datetime
from django.db import models

class CustomPrimaryKeyModel(models.Model):
    id = models.CharField(primary_key=True, max_length=20, editable=False)

    class Meta:
        abstract = True

    def generate_primary_key(self):
        current_year = datetime.datetime.now().year
        model_name_initials = self.__class__.__name__[:2].upper()  # Use first 2 letters of the model name
        unique_number = self.__class__.objects.count() + 1
        return f"{current_year}{model_name_initials}{unique_number:04d}"

    def save(self, *args, **kwargs):
        if not self.id:
            self.id = self.generate_primary_key()
        super().save(*args, **kwargs)