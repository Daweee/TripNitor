from ..serializers import RatingSerializer
from drf_spectacular.utils import extend_schema
from .mixins import CustomResponseMixin
from rest_framework.generics import (
    ListAPIView,
    RetrieveAPIView,
    CreateAPIView,
    UpdateAPIView,
    DestroyAPIView
)
from ..services import RatingService
from ..models import Rating
from rest_framework.exceptions import ValidationError, PermissionDenied
from rest_framework import status

@extend_schema(tags=['ratings'])
class RatingCreateView(CustomResponseMixin, CreateAPIView):
    serializer_class = RatingSerializer
    
    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        booking_id = serializer.validated_data.get('booking').id
        rating_value = serializer.validated_data.get('rating')
        comment = serializer.validated_data.get('comment', '')
        
        rating_service = RatingService()
        
        try:
            rating = rating_service.create_rating(
                booking_id=booking_id,
                user=request.user,
                rating=rating_value,
                comment=comment
            )
            serializer = self.get_serializer(rating)
            return self.get_custom_response(
                status.HTTP_201_CREATED,
                serializer.data,
                'Rating created successfully'
            )
        except ValidationError as e:
            return self.get_custom_response(
                status.HTTP_400_BAD_REQUEST,
                None,
                e.detail[0] if isinstance(e.detail, list) else e.detail
            )
        except PermissionDenied as e:
            return self.get_custom_response(
                status.HTTP_403_FORBIDDEN,
                None,
                str(e)
            )
        except Exception as e:
            return self.get_custom_response(
                status.HTTP_500_INTERNAL_SERVER_ERROR,
                None,
                f'An error occurred: {str(e)}'
            )
        
@extend_schema(tags=['ratings'])
class RatingListView(CustomResponseMixin, ListAPIView):
    serializer_class = RatingSerializer
    
    def get_queryset(self):
        return Rating.objects.all()
    
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        serializer = self.get_serializer(queryset, many=True)
        
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Ratings list retrieved successfully'
        )
    
@extend_schema(tags=['ratings'])
class RatingDetailView(CustomResponseMixin, RetrieveAPIView):
    queryset = Rating.objects.all()
    serializer_class = RatingSerializer
    
    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        serializer = self.get_serializer(instance)
        
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Rating details retrieved successfully'
        )

@extend_schema(tags=['ratings'])
class RatingUpdateView(CustomResponseMixin, UpdateAPIView):
    queryset = Rating.objects.all()
    serializer_class = RatingSerializer
    
    def update(self, request, *args, **kwargs):
        instance = self.get_object()
        
        if request.user != instance.user:
            return self.get_custom_response(
                status.HTTP_403_FORBIDDEN,
                None,
                'You are not authorized to update this rating'
            )
            
        serializer = self.get_serializer(instance, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        
        if 'rating' in serializer.validated_data:
            rating_service = RatingService()
            try:
                rating_service._validate_rating_value(
                    serializer.validated_data['rating'], 
                    "rating"
                )
            except ValidationError as e:
                return self.get_custom_response(
                    status.HTTP_400_BAD_REQUEST,
                    None,
                    e.detail[0] if isinstance(e.detail, list) else e.detail
                )
                
        rating = serializer.save()
        
        return self.get_custom_response(
            status.HTTP_200_OK,
            serializer.data,
            'Rating updated successfully'
        )