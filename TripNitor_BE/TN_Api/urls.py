from django.urls import path
from .views import RegisterView, LoginView, LogoutView

urlpatterns = [
    path('users/register/', RegisterView.as_view(), name='signup'),
    path('users/login/', LoginView.as_view(), name='login'),
    path('users/logout/', LogoutView.as_view(), name='logout'),

    # path('drivers/signup/', DriverSignupView.as_view(), name='driver_signup'),
    # path('drivers/login/', DriverLoginView.as_view(), name='driver_login'),
    # path('drivers/logout/', DriverLogoutView.as_view(), name='driver_logout'),
    # path('drivers/', DriverView.as_view(), name='driver-create'),
    # path('drivers/<int:driver_id>/', DriverView.as_view(), name='driver-detail'),
    # path('drivers/<int:driver_id>/assign-van/', AssignVanView.as_view(), name='assign-van'),
]