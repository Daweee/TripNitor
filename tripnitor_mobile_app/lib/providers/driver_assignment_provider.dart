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
        driverAssignmentList: [],
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

  Future<void> getAvailableDriversForSwap(
      String bookingId, DateTime startDate, DateTime endDate) async {
    state = state.copyWith(isLoading: true, error: null, availableDrivers: []);
    try {
      final drivers = await _driverAssignmentService.getAvailableDriversForSwap(
        bookingId,
        startDate,
        endDate,
      );
      state = state.copyWith(
        isLoading: false,
        availableDrivers: drivers,
        error: null,
        message: 'Available drivers retrieved successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load available drivers: $e',
        availableDrivers: [],
      );
    }
  }

  Future<void> reassignDrivers(int driverAssignmentId, String bookingId,
      String oldDriverId, String newDriverId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final driverAssignment = await _driverAssignmentService.reassignDrivers(
          driverAssignmentId, bookingId, oldDriverId, newDriverId);
      state = state.copyWith(
          isLoading: false,
          driverAssignment: driverAssignment,
          error: null,
          message: 'Driver reassigned successfully.');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to reassigned driver: $e',
      );
    }
  }

  Future<void> retrieveDriverAssignment(
      String bookingId, String driverId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final driverAssignment = await _driverAssignmentService
          .retrieveDriverAssignment(bookingId, driverId);
      state = state.copyWith(
          isLoading: false,
          driverAssignment: driverAssignment,
          error: null,
          message: 'Driver reassigned successfully.');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to reassigned driver: $e',
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
