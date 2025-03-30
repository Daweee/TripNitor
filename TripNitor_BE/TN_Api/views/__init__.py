from .user_view import RegisterView, LoginView, LogoutView, UserDetailView, GetUserWithAdminRole
from .driver_view import DriverCreateView, DriverListView, DriverDetailView, DriverUpdateView, DriverDeleteView, RetrieveDriverInstanceView
from .van_view import VanCreateView, VanListView, VanDetailView, VanUpdateView, VanDeleteView, UnassignedVanListView
from .gas_view import GasCreateView, GasListView, GasDetailView, GasUpdateView, GasDeleteView
from .package_view import PackageCreateView, PackageListView, PackageDetailView, PackageUpdateView, PackageDeleteView, CalculatePackageFareView
from .booking_view import (BookingListView, BookingCreateView, BookingDetailView, BookingUpdateView, BookingDeleteView, 
BookingPreviewView, UserBookingListView, GetBookingStatusListView, ConfirmBookingView, CancelBookingView, StartBookingView)
from .driver_assignment_view import DriverAssignmentList, DriverAssignmentByDriverList, DriverAssignmentRetrieveList, DriverActiveBookingsList, AvailableDriversForSwapView, SwapDriverView
from .location_view import LocationValidationView
from .booking_leg_view import SetBookingLegActiveView, CompleteBookingLegView
from .rating_view import RatingCreateView, RatingListView, RatingDetailView