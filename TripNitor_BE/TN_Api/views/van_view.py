from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from ..serializers import VanSerializer
from django.db import IntegrityError
from TN_Api.models import Van
from drf_spectacular.utils import extend_schema

@extend_schema(tags=['vans'])
class VanCreateView(CreateAPIView):
    serializer_class = VanSerializer
    permission = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            van = serializer.save()
            response_data = {
                'status': status.HTTP_201_CREATED,
                'data': {'van': serializer.data},
                'message': 'Van created successfully'
            }
            return Response(response_data, status=status.HTTP_201_CREATED)
        except IntegrityError as e:
            field_name = 'Unknown'
            if 'plate_number' in str(e):
                field_name = 'Plate Number'
            response_data = {
                'status': status.HTTP_400_BAD_REQUEST,
                'data': None,
                'message': f'A van with this {field_name} already exists.'
            }
            return Response(response_data, status=status.HTTP_400_BAD_REQUEST)

@extend_schema(tags=['vans'])        
class VanListView(ListAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)

        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'van': serializer.data},
            'message': 'Van list retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

@extend_schema(tags=['vans'])    
class VanDetailView(RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)

        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'van': serializer.data},
            'message': 'Van details retrieved successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

@extend_schema(tags=['vans'])    
class VanUpdateView(UpdateAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        van = serializer.save()

        response_data = {
            'status': status.HTTP_200_OK,
            'data': {'van': serializer.data},
            'message': 'Van details updated successfully'
        }
        return Response(response_data, status=status.HTTP_200_OK)

@extend_schema(tags=['vans'])    
class VanDeleteView(DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Van.objects.all()
    serializer_class = VanSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)

        response_data = {
            'status': status.HTTP_204_NO_CONTENT,
            'data': None,
            'message': 'Van deleted successfully'
        }
        return Response(response_data, status=status.HTTP_204_NO_CONTENT)
