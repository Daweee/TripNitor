import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/package_model.dart';
import '../services/package_service.dart';

class PackageNotifier extends StateNotifier<PackageState> {
  final PackageService _packageService;

  PackageNotifier(this._packageService) : super(PackageState());

  Future<void> getAllPackages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _packageService.getAllPackages();
      state = state.copyWith(
        packages: response,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> getPackageDetails(String packageId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _packageService.fetchPackageDetails(packageId);
      state = state.copyWith(
        selectedPackage: response,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createPackage(PackageCreate package) async {
    log('Starting package creation...', name: 'PackageNotifier');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final createdPackage = await _packageService.createPackage(package);

      if (createdPackage != null && createdPackage.id != null) {
        state = state.copyWith(
          isLoading: false,
          selectedPackage: createdPackage,
          error: null,
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.data?['status'] == 201) {
        try {
          final createdPackage = Package.fromJson(e.response!.data['data']);
          state = state.copyWith(
            isLoading: false,
            selectedPackage: createdPackage,
            error: null,
          );
          return;
        } catch (parseError) {
          rethrow;
        }
      }

      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final packageProvider =
    StateNotifierProvider<PackageNotifier, PackageState>((ref) {
  final packageService = ref.watch(packageServiceProvider);
  return PackageNotifier(packageService);
});

final packageServiceProvider =
    Provider<PackageService>((ref) => PackageService());

final packageTypeFilterProvider = StateProvider<String?>((ref) => null);
final visibilityFilterProvider = StateProvider<String?>((ref) => null);

final filteredPackagesProvider = Provider<List<Package>>((ref) {
  final packageState = ref.watch(packageProvider);
  final typeFilter = ref.watch(packageTypeFilterProvider);
  final visibilityFilter = ref.watch(visibilityFilterProvider);

  final filteredPackages = packageState.packages.where((package) {
    final matchesType = typeFilter == null || package.packageType == typeFilter;
    final matchesVisibility =
        visibilityFilter == null || package.visibility == visibilityFilter;
    return matchesType && matchesVisibility;
  }).toList();

  return filteredPackages;
});
