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

  Future<DriverCreationResponse> createDriver(
    String username,
    String name,
    String email,
    String phone_number,
    String password,
    String license_number,
    String? date_hired,
    String? van_id,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final driverCreationResponse = await _driverService.createDriver(
        username,
        name,
        email,
        phone_number,
        password,
        license_number,
        date_hired,
        van_id,
      );
      state = state.copyWith(
          isLoading: false,
          driverCreationResponse: driverCreationResponse,
          error: null,
          message: 'Driver account created successfully.');
      return driverCreationResponse;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to created driver account. $e',
      );
      rethrow;
    }
  }

  Future<void> deactivateDriver(String driverId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _driverService.deactivateDriver(driverId);

      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Driver account deactivated successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to deactivate driver account. $e',
      );
      throw e;
    }
  }

  Future<void> reactivateDriver(String driverId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _driverService.reactivateDriver(driverId);

      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Driver account reactivated successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to reactivate driver account. $e',
      );
      throw e;
    }
  }

  Future<Driver> updateDriver(String driverId, DriverPatch driver) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedDriver = await _driverService.updateDriver(driverId, driver);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Driver account updated successfully.',
      );
      return updatedDriver;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update driver. $e',
      );
      rethrow;
    }
  }

  Future<Driver> getUserDriverDetail() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final driver = await _driverService.getUserDriverDetail();
      state = state.copyWith(
          isLoading: false,
          driver: driver,
          error: null,
          message: 'Driver detail retrieved successfully.');
      return driver;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to retrieve driver details. $e',
      );
      rethrow;
    }
  }

  void clearState() {
    state = DriverState();
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
