from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from ..serializers import DriverCreationSerializer, DriverSerializer
from TN_Api.models import Driver
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from django.db import IntegrityError

class DriverCreateView(CreateAPIView):
    serializer_class = DriverCreationSerializer
    permission_classes = [IsAuthenticated] 

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            driver = serializer.save()
            response_data = {
                'status': status.HTTP_201_CREATED,
                'data': {'driver': serializer.data},
                'message': 'Driver account created successfully'
            }
            return Response(response_data, status=status.HTTP_201_CREATED)
        except IntegrityError as e:
            field_name = 'Unknown'
            if 'email' in str(e):
                field_name = 'Email'
            elif 'username' in str(e):
                field_name = 'Username'
            response_data = {
                'status': status.HTTP_400_BAD_REQUEST,
                'data': None,
                'message': f'A user with this {field_name} already exists.'
            }
            return Response(response_data, status=status.HTTP_400_BAD_REQUEST)

class DriverListView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = DriverSerializer
    queryset = Driver.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'drivers': serializer.data for driver in queryset},
            'message': 'Driver list successful'
        }
        return Response(response_data, status=status.HTTP_200_OK)

class DriverDetailView(RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = DriverSerializer
    queryset = Driver.objects.all()

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'driver': serializer.data},
            'message': 'Driver details retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

class DriverUpdateView(UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = DriverSerializer
    queryset = Driver.objects.all()

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        driver = serializer.save()

        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'driver': serializer.data},
            'message': 'Driver details updated successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)
    
class DriverDeleteView(DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        user = instance.user  # Get the associated User object

        # First, delete the Driver instance
        super().destroy(request, *args, **kwargs)
        
        # Then, delete the associated User
        user.delete()

        response_data = {
            'status': status.HTTP_204_NO_CONTENT,
            'data': None,
            'message': 'Driver deleted successfully'
        }
        return Response(response_data, status=status.HTTP_204_NO_CONTENT)