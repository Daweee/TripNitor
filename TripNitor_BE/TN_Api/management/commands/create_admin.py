from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError

User = get_user_model()

class Command(BaseCommand):
    help = 'Creates the single admin user for the application'

    def add_arguments(self, parser):
        parser.add_argument('username', type=str)
        parser.add_argument('email', type=str)
        parser.add_argument('name', type=str)
        parser.add_argument('phone_number', type=str)
        parser.add_argument('password', type=str)

    def handle(self, *args, **options):
        try:
            user = User.objects.create_superuser(
                username=options['username'],
                email=options['email'],
                name=options['name'],
                phone_number=options['phone_number'],
                password=options['password']
            )
            self.stdout.write(self.style.SUCCESS(f'Successfully created admin user "{user.username}"'))
        except ValidationError as e:
            self.stdout.write(self.style.ERROR(f'Error: {str(e)}'))