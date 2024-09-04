from rest_framework import serializers
from ..models import DriverAssignment

class DriverAssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = DriverAssignment
        fields = '__all__'