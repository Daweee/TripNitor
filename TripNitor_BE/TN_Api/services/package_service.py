from ..models import Gas, Leg, Location, Package, User, PackageUser
from django.db.models import Min, Q, Sum
from decimal import Decimal
from django.db import IntegrityError, transaction

class PackageService:
    @staticmethod
    def calculate_base_fare(total_distance):
        lowest_gas_price = Gas.objects.aggregate(Min('gas_price'))['gas_price__min']
        if lowest_gas_price is not None:
            price_per_km = Decimal(lowest_gas_price) / Decimal('10')
            distance_cost = price_per_km * Decimal(str(total_distance))
            return distance_cost.quantize(Decimal('0.01'))
        return Decimal('0') 
    
    @staticmethod
    def normalize_decimal(value):
        return Decimal(str(value)).quantize(Decimal('0.000001'))
    
    @staticmethod
    def find_or_create_location(location_data):
        """
        Find existing location or create new one if it doesn't exist
        Handles race conditions and data normalization
        """
        if not location_data:
            return None

        # Normalize decimal values
        normalized_data = {
            'name': location_data['name'].strip(),
            'address': location_data['address'].strip(),
            'latitude': PackageService.normalize_decimal(location_data['latitude']),
            'longitude': PackageService.normalize_decimal(location_data['longitude'])
        }

        # First try exact match
        try:
            return Location.objects.get(**normalized_data)
        except Location.DoesNotExist:
            # If no exact match, try to create
            try:
                return Location.objects.create(**normalized_data)
            except IntegrityError:
                # If creation fails due to race condition, get the existing record
                return Location.objects.get(**normalized_data)

    @classmethod
    def handle_leg_update(cls, package, leg_data, existing_leg=None):
        """Handle creation or update of a leg with location management"""
        try:
            with transaction.atomic():
                # Extract location data
                start_loc_data = leg_data.pop('start_location', None)
                end_loc_data = leg_data.pop('end_location', None)

                # Find or create locations
                start_location = cls.find_or_create_location(start_loc_data) if start_loc_data else None
                end_location = cls.find_or_create_location(end_loc_data) if end_loc_data else None

                if existing_leg:
                    # Update existing leg
                    if start_location:
                        existing_leg.start_location = start_location
                    if end_location:
                        existing_leg.end_location = end_location
                    
                    # Remove id from leg_data if present to avoid conflicts
                    leg_data.pop('id', None)
                    
                    # Update other fields
                    for key, value in leg_data.items():
                        setattr(existing_leg, key, value)
                    
                    existing_leg.save()
                    return existing_leg
                else:
                    # Remove id from leg_data if present (for new legs)
                    leg_data.pop('id', None)
                    
                    # Create new leg
                    return Leg.objects.create(
                        package=package,
                        start_location=start_location,
                        end_location=end_location,
                        **leg_data
                    )
        except Exception as e:
            print(f"Error in handle_leg_update: {str(e)}")
            raise

    @classmethod
    def update_package(cls, package_instance, validated_data):
        """Update a package and its related objects"""
        with transaction.atomic():
            # Handle start location
            if 'start_location' in validated_data:
                package_instance.start_location = cls.find_or_create_location(
                    validated_data.pop('start_location')
                )

            # Handle final destination
            if 'final_destination' in validated_data:
                package_instance.final_destination = cls.find_or_create_location(
                    validated_data.pop('final_destination')
                )

            if 'legs' in validated_data:
                cls.update_package_legs(package_instance, validated_data.pop('legs'))

            # Update base price if needed
            if 'base_price' not in validated_data and 'total_distance' in validated_data:
                validated_data['base_price'] = cls.calculate_base_fare(validated_data['total_distance'])

            # Update remaining package fields
            for attr, value in validated_data.items():
                setattr(package_instance, attr, value)

            package_instance.save()
            return package_instance

    @classmethod
    def update_package_legs(cls, package, legs_updates):
        """
        Replace all package legs with the new updates
        """      

        with transaction.atomic():
            package.legs.all().delete()

            final_legs = []
            for leg_data in legs_updates:
                leg_data.pop('id', None)

                new_leg = cls.handle_leg_update(package, dict(leg_data))
                final_legs.append(new_leg)
            
            final_legs.sort(key=lambda x: x.leg_number)
            return final_legs

    @classmethod
    def create_package(cls, validated_data):
        """Create a new package with all related objects"""
        with transaction.atomic():
            legs_data = validated_data.pop('legs', [])
            
            # Calculate base price if not provided
            if 'base_price' not in validated_data and 'total_distance' in validated_data:
                validated_data['base_price'] = cls.calculate_base_fare(
                    validated_data['total_distance']
                )

            # Handle locations once
            validated_data['start_location'] = cls.find_or_create_location(
                validated_data.pop('start_location', None)
            )
            validated_data['final_destination'] = cls.find_or_create_location(
                validated_data.pop('final_destination', None)
            )

            # Create package
            package = Package.objects.create(**validated_data)

            # Create legs
            for leg_data in legs_data:
                cls.handle_leg_update(package, leg_data.copy())
                
            return package
        
    @classmethod 
    def create_joiner_package(cls, validated_data):

        with transaction.atomic():
            legs_data = validated_data.pop('legs', [])
            start_date = validated_data.pop('start_date')
            end_date = validated_data.pop('end_date')

            if 'base_price' not in validated_data and 'total_distance' in validated_data:
                validated_data['base_price'] = cls.calculate_base_fare(
                    validated_data['total_distance']
                )

            # Handle locations once
            validated_data['start_location'] = cls.find_or_create_location(
                validated_data.pop('start_location', None)
            )
            validated_data['final_destination'] = cls.find_or_create_location(
                validated_data.pop('final_destination', None)
            )

            from ..services import BookingService
            assigned_driver = BookingService.assign_driver_for_joiner(start_date, end_date)
            if not assigned_driver:
                raise ValueError("No available drivers found for the specified date range.")

            validated_data['assigned_driver'] = assigned_driver
            validated_data['start_date'] = start_date
            validated_data['end_date'] = end_date

            package = Package.objects.create(**validated_data)

            # Create legs
            for leg_data in legs_data:
                cls.handle_leg_update(package, leg_data.copy())
                
            return package
        
    @staticmethod
    def join_package(package_id, user_id, number_of_passengers):
    
        try:
            with transaction.atomic():
                package = Package.objects.select_for_update().get(id=package_id)
                user = User.objects.get(id=user_id)

                if not hasattr(package, 'visibility') or package.visibility != Package.PackageVisibility.JOINER:
                    raise ValueError("Only packages of type JOINER can be joined")
                
                if PackageUser.objects.filter(user_id=user_id, package_id=package_id).exists():
                    raise ValueError("User has already joined this package")
                    
                current_passengers = PackageUser.objects.filter(package=package).aggregate(
                total=Sum('number_of_passengers')
                )['total'] or 0
                
                if current_passengers + number_of_passengers > 15:
                    remaining_spots = max(0, 15 - current_passengers)
                    raise ValueError(
                        f"Cannot add {number_of_passengers} passengers. "
                        f"Package has only {remaining_spots} spots remaining."
                    )
                    
                package_user = PackageUser.objects.create(
                    user=user,
                    package=package,
                    number_of_passengers=number_of_passengers
                )

                package.current_participants = current_passengers + number_of_passengers
                package.save(update_fields=['current_participants'])
                
                return package_user
                
        except Package.DoesNotExist:
            raise ValueError(f"Package with ID {package_id} does not exist")
        except User.DoesNotExist:
            raise ValueError(f"User with ID {user_id} does not exist")
        except IntegrityError as e:
            raise ValueError(f"Failed to join package: {str(e)}")
        except Exception as e:
            if hasattr(e, 'message'):
                raise ValueError(e.message)
            raise ValueError(str(e))