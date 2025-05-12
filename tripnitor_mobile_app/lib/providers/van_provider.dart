import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tripnitor_mobile_app/models/van_model.dart';

import '../services/van_service.dart';

class VanStateNotifier extends StateNotifier<VanState> {
  VanService _vanService;

  VanStateNotifier(this._vanService) : super(VanState());

  Future<void> getAllVans() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final vanList = await _vanService.getVanList();
      state = state.copyWith(
        isLoading: false,
        vanList: vanList,
        message: 'Van list retrieved successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load van list: $e',
      );
    }
  }

  Future<void> getAllUnassignedVans() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final vanList = await _vanService.getUnassignedVanList();
      state = state.copyWith(
        isLoading: false,
        vanList: vanList,
        message: 'Unassigned vans list retrieved successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load unassigned vans list: $e',
      );
    }
  }

  Future<void> getUnassignedVansAndDriverVan(String? currentVanId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final List<Van> unassignedVans = await _vanService.getUnassignedVanList();

      if (currentVanId != null &&
          !unassignedVans.any((van) => van.id == currentVanId)) {
        try {
          final Van currentVan = await _vanService.getVanDetail(currentVanId);
          unassignedVans.add(currentVan);
        } catch (e) {
          print('Could not fetch van with ID $currentVanId: $e');
        }
      }

      state = state.copyWith(
        vanList: unassignedVans,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      throw e;
    }
  }

  Future<void> getVanDetail(String vanId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final van = await _vanService.getVanDetail(vanId);
      state = state.copyWith(
        isLoading: false,
        van: van,
        error: null,
        message: 'Van details retrieved successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load van details: $e',
      );
    }
  }

  Future<Van> createVan(VanPatch vanPatch) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdVan = await _vanService.createVan(vanPatch);
      state = state.copyWith(
        isLoading: false,
        van: createdVan,
        error: null,
        message: 'Van created successfully',
      );
      return createdVan;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create van: $e',
      );
      rethrow;
    }
  }

  Future<void> deleteVan(String vanId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _vanService.deleteVan(vanId);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Van deleted successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete van: $e',
      );
    }
  }

  Future<Van> updateVan(String vanId, VanPatch van) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedVan = await _vanService.updateVan(vanId, van);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Van updated successfully.',
      );
      return updatedVan;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update van. $e',
      );
      rethrow;
    }
  }
}

final vanServiceProvider = Provider<VanService>((ref) {
  return VanService();
});

final vanStateProvider =
    StateNotifierProvider<VanStateNotifier, VanState>((ref) {
  final vanService = ref.watch(vanServiceProvider);
  return VanStateNotifier(vanService);
});
