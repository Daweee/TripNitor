import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/driver_assignment.dart';
import 'package:tripnitor_mobile_app/services/driver_assignment_service.dart';

class DriverAssignmentStateNotifier
    extends StateNotifier<DriverAssignmentState> {
  DriverAssignmentService _driverAssignmentService;

  DriverAssignmentStateNotifier(this._driverAssignmentService)
      : super(DriverAssignmentState());

  Future<void> getDriverBookings() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final driverAssignmentList =
          await _driverAssignmentService.getAllDriverAssignedBookings();
      state = state.copyWith(
          isLoading: false,
          driverAssignmentList: driverAssignmentList,
          error: null,
          message: 'Driver booking list retrieved successfully.');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load driver booking list: $e',
      );
    }
  }

  Future<void> getAllSpecificDriverBookings(String driverId) async {
    // Clear the list before fetching new data
    state =
        state.copyWith(isLoading: true, error: null, driverAssignmentList: []);
    try {
      final driverBookingsList =
          await _driverAssignmentService.getAllSpecificDriverBookings(driverId);
      state = state.copyWith(
          isLoading: false,
          driverAssignmentList: driverBookingsList,
          error: null,
          message: 'Driver booking schedule list retrieved successfully.');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load driver booking schedule list: $e',
        driverAssignmentList: [], // Ensure list is cleared on error
      );
    }
  }

  Future<void> getActiveDriverBookingsList() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final confirmedDriverBookings =
          await _driverAssignmentService.getActiveDriverBookingsList();
      state = state.copyWith(
        isLoading: false,
        driverAssignmentList: confirmedDriverBookings,
        error: null,
        message: 'Confirmed driver booking list retrieved successfully.',
      );
    } catch (e) {
      state.copyWith(
        isLoading: false,
        error: 'Failed to load confirmed driver booking list: $e',
        driverAssignmentList: [],
      );
    }
  }

  void clearState() {
    state = DriverAssignmentState();
  }
}

final driverAssignmentServiceProvider =
    Provider<DriverAssignmentService>((ref) {
  return DriverAssignmentService();
});

final driverAssignmentStateProvider =
    StateNotifierProvider<DriverAssignmentStateNotifier, DriverAssignmentState>(
        (ref) {
  final driverAssignmentService = ref.watch(driverAssignmentServiceProvider);
  return DriverAssignmentStateNotifier(driverAssignmentService);
});
