import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/gas_model.dart';
import '../services/gas_service.dart';

class GasStateNotifier extends StateNotifier<GasState> {
  GasService _gasService;

  GasStateNotifier(this._gasService) : super(GasState());

  Future<void> getAllGas() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final gasList = await _gasService.getGasList();
      state = state.copyWith(
        isLoading: false,
        gasList: gasList,
        message: 'Gas list retrieved successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load gas list: $e',
      );
    }
  }

  Future<void> getGasDetail(String gasId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final gas = await _gasService.getGasDetail(gasId);
      state = state.copyWith(
        isLoading: false,
        gas: gas,
        error: null,
        message: 'Gas details retrieved successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load gas details: $e',
      );
    }
  }

  Future<void> createGas(Gas gas) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final createdGas = await _gasService.createGas(gas);
      state = state.copyWith(
        isLoading: false,
        gas: createdGas,
        error: null,
        message: 'Gas created successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create gas: $e',
      );
    }
  }

  Future<void> deleteGas(String gasId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _gasService.deleteGas(gasId);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Gas deleted successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete gas: $e',
      );
    }
  }

  Future<void> updateGas(String gasId, Gas gas) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _gasService.updateGas(gasId, gas);
      state = state.copyWith(
        isLoading: false,
        error: null,
        message: 'Gas updated successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update gas. $e',
      );
    }
  }
}

final gasServiceProvider = Provider<GasService>((ref) {
  return GasService();
});

final gasStateProvider =
    StateNotifierProvider<GasStateNotifier, GasState>((ref) {
  final gasService = ref.watch(gasServiceProvider);
  return GasStateNotifier(gasService);
});
