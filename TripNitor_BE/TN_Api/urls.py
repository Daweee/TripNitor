from django.urls import path
from .views import (
    RegisterView, LoginView, LogoutView, UserDetailView, 
    DriverCreateView,DriverListView,DriverDetailView,DriverUpdateView,DriverDeleteView,
    VanCreateView, VanListView, VanDetailView, VanUpdateView, VanDeleteView, UnassignedVanListView,
    GasCreateView, GasListView, GasDetailView, GasUpdateView, GasDeleteView,
    BookingCreateView, BookingListView, BookingDetailView, BookingUpdateView, BookingDeleteView, BookingPreviewView, UserBookingListView, GetBookingStatusListView,
    PackageCreateView, PackageListView, PackageDetailView, PackageUpdateView, PackageDeleteView
)

urlpatterns = [
    path('users/register/', RegisterView.as_view(), name='register'),
    path('users/login/', LoginView.as_view(), name='login'),
    path('users/logout/', LogoutView.as_view(), name='logout'),
    path('users/<str:pk>/', UserDetailView.as_view(), name='get_user'),

    path('drivers/register/', DriverCreateView.as_view(), name='register_driver'),
    path('drivers/', DriverListView.as_view(), name='driver_list'),
    path('drivers/<str:id>/', DriverDetailView.as_view(), name='get_driver'),
    path('drivers/<str:id>/update/', DriverUpdateView.as_view(), name='update_driver'),
    path('drivers/<str:id>/delete/', DriverDeleteView.as_view(), name='delete_driver'),

    path('vans/register/', VanCreateView.as_view(), name='register_van'),
    path('vans/', VanListView.as_view(), name='van_list'),
    path('vans/unassigned/', UnassignedVanListView.as_view(), name='unassigned_van_list'),
    path('vans/<str:pk>/', VanDetailView.as_view(), name='get_van'),
    path('vans/<str:pk>/update/', VanUpdateView.as_view(), name='update_van'),
    path('vans/<str:pk>/delete', VanDeleteView.as_view(), name='delete_van'),

    path('gas/register/', GasCreateView.as_view(), name='register_gas'),
    path('gas/', GasListView.as_view(), name='gas_list'),
    path('gas/<str:pk>/', GasDetailView.as_view(), name='get_gas'),
    path('gas/<str:pk>/update/', GasUpdateView.as_view(), name='update_gas'),
    path('gas/<str:pk>/delete/', GasDeleteView.as_view(), name='delete_gas'),

    path('bookings/user-bookings/', UserBookingListView.as_view(), name='user-bookings'),
    path('bookings/status/<str:bookingstatus>/', GetBookingStatusListView.as_view(), name='booking-status'),
    path('bookings/', BookingListView.as_view(), name='booking-list'),
    path('bookings/preview-booking/', BookingPreviewView.as_view(), name='preview-bookin'),
    path('bookings/create/', BookingCreateView.as_view(), name='booking-create'),
    path('bookings/<str:pk>/', BookingDetailView.as_view(), name='booking-detail'),
    path('bookings/<str:pk>/update/', BookingUpdateView.as_view(), name='booking-update'),
    path('bookings/<str:pk>/delete/', BookingDeleteView.as_view(), name='booking-delete'),

    path('packages/register/', PackageCreateView.as_view(), name='register_package'),
    path('packages/', PackageListView.as_view(), name='package_list'),
    path('packages/<str:pk>/', PackageDetailView.as_view(), name='get_package'),
    path('packages/<str:pk>/update/', PackageUpdateView.as_view(), name='update_package'),
    path('packages/<str:pk>/delete', PackageDeleteView.as_view(), name='delete_package'),
]