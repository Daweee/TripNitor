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

  Future<void> createVan(Van van) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdVan = await _vanService.createVan(van);
      state = state.copyWith(
        isLoading: false,
        van: createdVan,
        error: null,
        message: 'Van created successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create van: $e',
      );
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

  Future<void> updateVan(String vanId, Van van) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _vanService.updateVan(vanId, van);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Van updated successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update van. $e',
      );
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
