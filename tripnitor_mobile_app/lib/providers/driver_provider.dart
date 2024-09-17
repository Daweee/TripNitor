import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';
import 'package:tripnitor_mobile_app/services/driver_service.dart';

class DriverStateNotifier extends StateNotifier<DriverState> {
  final DriverService _driverService;

  DriverStateNotifier(this._driverService) : super(DriverState());

  Future<void> getDriverList() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final driverList = await _driverService.getDriverList();
      state = state.copyWith(
        isLoading: false,
        driverList: driverList,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load list of drivers: $e',
      );
    }
  }

  Future<void> getDriverDetail(String driverId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final driver = await _driverService.getDriverDetail(driverId);
      state = state.copyWith(
        isLoading: false,
        driver: driver,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load driver details: $e',
      );
    }
  }

  Future<void> createDriver(Driver driver) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdDriver = await _driverService.createDriver(driver);
      state = state.copyWith(
          isLoading: false,
          driver: createdDriver,
          error: null,
          message: 'Driver account created successfully.');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to created driver account. $e',
      );
    }
  }

  Future<void> deleteDriver(String driverId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _driverService.deleteDriver(driverId);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Driver account deleted successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete driver account. $e',
      );
    }
  }

  Future<void> updateDriver(String driverId, Driver driver) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _driverService.updateDriver(driverId, driver);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Driver account updated successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update van. $e',
      );
    }
  }
}

final driverServiceProvider = Provider<DriverService>((ref) {
  return DriverService();
});

final driverStateProvider =
    StateNotifierProvider<DriverStateNotifier, DriverState>((ref) {
  final driverService = ref.watch(driverServiceProvider);
  return DriverStateNotifier(driverService);
});
