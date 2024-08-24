from django.urls import path
from .views import (
    RegisterView, LoginView, LogoutView, 
    DriverCreateView,DriverListView,DriverDetailView,DriverUpdateView,DriverDeleteView,
    VanCreateView, VanListView, VanDetailView, VanUpdateView, VanDeleteView,
    GasCreateView, GasListView, GasDetailView, GasUpdateView, GasDeleteView
)

urlpatterns = [
    path('users/register/', RegisterView.as_view(), name='register'),
    path('users/login/', LoginView.as_view(), name='login'),
    path('users/logout/', LogoutView.as_view(), name='logout'),

    path('drivers/register/', DriverCreateView.as_view(), name='register_driver'),
    path('drivers/', DriverListView.as_view(), name='driver_list'),
    path('drivers/<int:pk>/', DriverDetailView.as_view(), name='get_driver'),
    path('drivers/<int:pk>/update/', DriverUpdateView.as_view(), name='update_driver'),
    path('drivers/<int:pk>/delete/', DriverDeleteView.as_view(), name='delete_driver'),

    path('vans/register/', VanCreateView.as_view(), name='register_van'),
    path('vans/', VanListView.as_view(), name='van_list'),
    path('vans/<int:pk>/', VanDetailView.as_view(), name='get_van'),
    path('vans/<int:pk>/update/', VanUpdateView.as_view(), name='update_van'),
    path('vans/<int:pk>/delete', VanDeleteView.as_view(), name='delete_van'),

    path('gas/register/', GasCreateView.as_view(), name='register_gas'),
    path('gas/', GasListView.as_view(), name='van_gas'),
    path('gas/<int:pk>/', GasDetailView.as_view(), name='get_gas'),
    path('gas/<int:pk>/update/', GasUpdateView.as_view(), name='update_gas'),
    path('gas/<int:pk>/delete', GasDeleteView.as_view(), name='delete_gas'),
]