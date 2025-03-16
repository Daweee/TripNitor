from ..models import Gas, Leg, Location, Package
from django.db.models import Min, Q
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
            
        # # Use get_or_create which handles the race condition atomically
        # location, created = Location.objects.get_or_create(
        #     **normalized_data,
        #     defaults=normalized_data  # Same values for creation if needed
        # )

        # return location

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

    # @classmethod
    # def handle_leg_update(cls, package, leg_data, existing_leg=None):
    #     """Handle creation or update of a leg with location management"""
    #     # Handle locations
    #     start_loc_data = leg_data.pop('start_location', None)
    #     end_loc_data = leg_data.pop('end_location', None)

    #     # Find or create locations
    #     start_location = cls.find_or_create_location(start_loc_data) if start_loc_data else None
    #     end_location = cls.find_or_create_location(end_loc_data) if end_loc_data else None

    #     # ORIGINAL
    #     # if existing_leg:
    #     #     # Update existing leg
    #     #     existing_leg.start_location = start_location or existing_leg.start_location
    #     #     existing_leg.end_location = end_location or existing_leg.end_location
    #     #     for key, value in leg_data.items():
    #     #         setattr(existing_leg, key, value)
    #     #     existing_leg.save()
    #     #     return existing_leg
    #     # else:
    #     #     # Create new leg
    #     #     return Leg.objects.create(
    #     #         package=package,
    #     #         start_location=start_location,
    #     #         end_location=end_location,
    #     #         **leg_data
    #     #     )

    #     if existing_leg:
    #         # Update existing leg
    #         if start_location:
    #             existing_leg.start_location = start_location
    #         if end_location:
    #             existing_leg.end_location = end_location
    #         for key, value in leg_data.items():
    #             setattr(existing_leg, key, value)
    #         existing_leg.save()
    #         return existing_leg
    #     else:
    #         # Create new leg
    #         leg_data['start_location'] = start_location
    #         leg_data['end_location'] = end_location
    #         leg_data['package'] = package
    #         return Leg.objects.create(**leg_data)
    
    # @classmethod
    # def update_package_legs(cls, package, legs_updates):
    #     """
    #     Update package legs handling:
    #     - Addition of new legs (legs without id field)
    #     - Removal of legs (legs not in the update)
    #     - Updates to existing legs (including location changes and leg number changes)
    #     """
    #     with transaction.atomic():
    #         # Get existing legs and their IDs
    #         existing_legs = list(package.legs.all())
    #         existing_leg_map = {leg.id: leg for leg in existing_legs}

    #         # Track legs to update and create
    #         final_legs = []
            
    #         for leg_data in legs_updates:
    #             leg_id = leg_data.get('id')
                
    #             if leg_id and leg_id in existing_leg_map:
    #                 # Update existing leg
    #                 existing_leg = existing_leg_map[leg_id]
    #                 updated_leg = cls.handle_leg_update(
    #                     package, 
    #                     dict(leg_data),  # Create a copy of the data
    #                     existing_leg
    #                 )
    #                 final_legs.append(updated_leg)
    #             else:
    #                 # Create new leg
    #                 new_leg = cls.handle_leg_update(
    #                     package,
    #                     dict(leg_data)  # Create a copy of the data
    #                 )
    #                 final_legs.append(new_leg)
            
    #         # Delete legs that weren't included in the update
    #         updated_leg_ids = {leg_data.get('id') for leg_data in legs_updates if leg_data.get('id')}
    #         for leg in existing_legs:
    #             if leg.id not in updated_leg_ids:
    #                 leg.delete()
            
    #         # Sort legs by leg_number
    #         final_legs.sort(key=lambda x: x.leg_number)
    #         return final_legs
    # def update_package_legs(cls, package, legs_updates):
    #     """
    #     Update package legs handling:
    #     - Addition of new legs (legs without id field)
    #     - Removal of legs (legs not in the update)
    #     - Updates to existing legs (including location changes and leg number changes)
    #     """
    #     with transaction.atomic():
    #         # Get existing legs mapped by ID
    #         existing_legs = {leg.id: leg for leg in package.legs.all()}
        
    #         # Track which legs should remain
    #         updated_leg_ids = {leg_data['id'] for leg_data in legs_updates if leg_data.get('id')}
            
    #         # Remove legs that aren't in the updates
    #         legs_to_delete = set(existing_legs.keys()) - updated_leg_ids
    #         for leg_id in legs_to_delete:
    #             existing_legs[leg_id].delete()
            
    #         # Update existing legs and add new ones
    #         final_legs = []
            
    #         for leg_data in legs_updates:
    #             leg_id = leg_data.get('id')
    #             existing_leg = existing_legs.get(leg_id) if leg_id else None
                
    #             updated_leg = cls.handle_leg_update(
    #                 package, 
    #                 leg_data.copy(), 
    #                 existing_leg
    #             )
    #             final_legs.append(updated_leg)
            
    #         return final_legs

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

            # Handle legs (ORIGINAL)
            # if 'legs' in validated_data:
            #     legs_data = validated_data.pop('legs')
            #     existing_legs = list(package_instance.legs.all())
                
            #     # Update or create legs
            #     for index, leg_data in enumerate(legs_data):
            #         if index < len(existing_legs):
            #             cls.handle_leg_update(package_instance, leg_data.copy(), existing_legs[index])
            #         else:
            #             cls.handle_leg_update(package_instance, leg_data.copy())

            #     # Remove excess legs
            #     if len(legs_data) < len(existing_legs):
            #         for leg in existing_legs[len(legs_data):]:
            #             leg.delete()

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