from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from .models import DriverAssignment
from .serializers import DriverAssignmentSerializer
from drf_spectacular.utils import extend_schema

@extend_schema(tags=['driver assignments'])
class DriverAssignmentList(ListAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer

@extend_schema(tags=['driver assignments'])
class DriverAssignmentCreate(CreateAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer

@extend_schema(tags=['driver assignments'])
class DriverAssignmentRetrieve(RetrieveAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer

@extend_schema(tags=['driver assignments'])
class DriverAssignmentUpdate(UpdateAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer

@extend_schema(tags=['driver assignments'])
class DriverAssignmentDestroy(DestroyAPIView):
    queryset = DriverAssignment.objects.all()
    serializer_class = DriverAssignmentSerializer