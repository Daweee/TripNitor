import datetime
from django.db import models
from django.db.models import Max

class CustomPrimaryKeyModel(models.Model):
    id = models.CharField(primary_key=True, max_length=20, editable=False)

    class Meta:
        abstract = True

    def generate_primary_key(self):
        current_year = datetime.datetime.now().year
        model_name_initials = self.__class__.__name__[:2].upper()
        
        max_id = self.__class__.objects.filter(id__startswith=f"{current_year}{model_name_initials}").aggregate(Max('id'))['id__max']
        
        if max_id:
            max_number = int(max_id[-4:])
            new_number = max_number + 1
        else:
            new_number = 1
        
        return f"{current_year}{model_name_initials}{new_number:04d}"

    def save(self, *args, **kwargs):
        if not self.id:
            self.id = self.generate_primary_key()
        super().save(*args, **kwargs)