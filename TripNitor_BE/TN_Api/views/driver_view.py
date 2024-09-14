from django.forms import ValidationError
from django.shortcuts import get_object_or_404
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from ..serializers import DriverCreationSerializer, DriverSerializer
from TN_Api.models import Driver, User
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from django.db import IntegrityError
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin

@extend_schema(tags=['drivers'])
class DriverCreateView(CustomResponseMixin, CreateAPIView):
    serializer_class = DriverCreationSerializer
    permission_classes = [IsAuthenticated] 

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            driver = serializer.save()
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                serializer.data,
                'Driver account created successfully'
            )
        except IntegrityError as e:
            field_name = 'Unknown'
            if 'email' in str(e):
                field_name = 'Email'
            elif 'username' in str(e):
                field_name = 'Username'
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                f'A user with this {field_name} already exists.'
            )
        except ValidationError as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                str(e)
            )

@extend_schema(tags=['drivers'])
class DriverListView(CustomResponseMixin, ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = DriverSerializer
    queryset = Driver.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Driver list successful'
        )
    
@extend_schema(tags=['drivers'])
class DriverDetailView(CustomResponseMixin, RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = DriverSerializer
    queryset = Driver.objects.all()
    lookup_field = 'user__id'

    def retrieve(self, request, *args, **kwargs):
        try:
            instance = self.get_object()
            serializer = self.get_serializer(instance)
            return self.get_custom_response(
                status.HTTP_200_OK,
                serializer.data,
                'Driver details retrieved successfully'
            )
        except Driver.DoesNotExist:
            return self.get_custom_response(
                status.HTTP_404_NOT_FOUND,
                None,
                "No Driver matches the given query."
            , status=status.HTTP_404_NOT_FOUND)

    def get_object(self):
        user_id = self.kwargs.get(self.lookup_field)
        try:
            user = User.objects.get(id=user_id)
            driver = get_object_or_404(Driver, user=user)
            self.check_object_permissions(self.request, driver)
            return driver
        except User.DoesNotExist:
            raise Driver.DoesNotExist

    # def retrieve(self, request, *args, **kwargs):
    #     instance = self.get_object()
    #     serializer = self.get_serializer(instance)

    #     return self.get_custom_response(
    #         status.HTTP_200_OK,
    #         serializer.data,
    #         'Driver details retrieved successfully'
    #     )

@extend_schema(tags=['drivers'])
class DriverUpdateView(CustomResponseMixin, UpdateAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = DriverSerializer
    queryset = Driver.objects.all()

    def update(self, request, *args, **kwargs):
        partial = kwargs.pop('partial', False)
        instance = self.get_object()
        serializer = self.get_serializer(instance, data=request.data, partial=partial)
        serializer.is_valid(raise_exception=True)
        try:
            driver = serializer.save()
            return self.get_custom_response(
                status.HTTP_200_OK,
                serializer.data,
                'Driver details updated successfully'
            )
        except ValidationError as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                str(e)
            )

@extend_schema(tags=['drivers'])    
class DriverDeleteView(CustomResponseMixin, DestroyAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        user = instance.user  

        super().destroy(request, *args, **kwargs)
        user.delete()

        return self.get_custom_response(
            status.HTTP_204_NO_CONTENT,
            None,
            'Driver deleted successfully'
        )