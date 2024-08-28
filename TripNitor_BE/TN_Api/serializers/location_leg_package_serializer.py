from rest_framework import serializers
from TN_Api.models import Package, Location, Leg

class LocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Location
        fields = ['id', 'latitude', 'longitude']


class LegSerializer(serializers.ModelSerializer):
    start_location = LocationSerializer()
    end_location = LocationSerializer()

    class Meta:
        model = Leg
        fields = ['leg_number', 'start_location', 'end_location', 'departure_time', 'arrival_time']

    def create(self, validated_data):
        start_location_data = validated_data.pop('start_location')
        end_location_data = validated_data.pop('end_location')
        start_location, _ = Location.objects.get_or_create(**start_location_data)
        end_location, _ = Location.objects.get_or_create(**end_location_data)
        package = validated_data.pop('package')  # Make sure package is included
        return Leg.objects.create(start_location=start_location, end_location=end_location, package=package, **validated_data)

class PackageSerializer(serializers.ModelSerializer):
    legs = LegSerializer(many=True)

    class Meta:
        model = Package
        fields = ['id', 'package_name', 'description', 'base_price', 'duration', 'legs']

    def create(self, validated_data):
        legs_data = validated_data.pop('legs')
        package = Package.objects.create(**validated_data)
        for leg_data in legs_data:
            # Assign the package to each leg before saving
            leg_data['package'] = package
            LegSerializer.create(LegSerializer(), validated_data=leg_data)
        return package