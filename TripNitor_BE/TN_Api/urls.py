from django.urls import path
from .views import (
    RegisterView, 
    LoginView, 
    LogoutView, 
    DriverCreateView,
    DriverListView,
    DriverDetailView,
    DriverUpdateView,
    DriverDeleteView
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
]