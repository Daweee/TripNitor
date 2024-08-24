from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from .base_model import CustomPrimaryKeyModel

class CustomUserManager(BaseUserManager):
    def create_user(self, username, email, name, phone_number, password=None, **extra_fields):
        if not username:
            raise ValueError('The given username must be set')
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        username = self.model.normalize_username(username)
        user = self.model(username=username, email=email, name=name, phone_number=phone_number, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, email, name, phone_number, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(username, email, name, phone_number, password, **extra_fields)

class User(AbstractUser, CustomPrimaryKeyModel):
    class Role(models.TextChoices):
        USER = 'USER', 'Regular User'
        DRIVER = 'DRIVER', 'Driver'
        MANAGER = 'MANAGER', 'Manager/Admin'

    username = models.CharField(max_length=255, unique=True)
    name = models.CharField(max_length=255)
    email = models.EmailField(unique=True)
    phone_number = models.CharField(max_length=20)
    role = models.CharField(max_length=10, choices=Role.choices, default=Role.USER)
    is_active = models.BooleanField(default=True)

    first_name = None
    last_name = None

    objects = CustomUserManager()

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email', 'name', 'phone_number']

    def __str__(self):
        return f"{self.username} - {self.get_role_display()}"