from drf_spectacular.utils import extend_schema
from rest_framework.generics import (
    ListAPIView,
)
from rest_framework import status
from rest_framework.exceptions import PermissionDenied, NotFound
from .mixins import CustomResponseMixin
from ..models import PackageUser, Package
from ..serializers import PackageUserSerializer

@extend_schema(tags=['package_users'])
class PackageUserListView(CustomResponseMixin, ListAPIView):
    serializer_class = PackageUserSerializer
    
    def get_queryset(self):
        package_id = self.kwargs.get('pk')
        
        try:
            package = Package.objects.get(pk=package_id)
            if package.visibility != Package.PackageVisibility.JOINER:
                raise PermissionDenied("This package does not allow joiners")
        except Package.DoesNotExist:
            raise NotFound("Package not found")
            
        return PackageUser.objects.filter(package_id=package_id)
    
    def list(self, request, *args, **kwargs):
        try:
            queryset = self.get_queryset()
            serializer = self.get_serializer(queryset, many=True)
            
            return self.get_custom_response(
                status.HTTP_200_OK,
                serializer.data,
                'Joiner package users retrieved successfully'
            )
        except PermissionDenied as e:
            return self.get_custom_response(
                status.HTTP_403_FORBIDDEN,
                None,
                str(e)
            )
        except NotFound as e:
            return self.get_custom_response(
                status.HTTP_404_NOT_FOUND,
                None,
                str(e)
            )
        except Exception as e:
            return self.get_custom_response(
                status.HTTP_500_INTERNAL_SERVER_ERROR,
                None,
                f'An error occurred: {str(e)}'
            )