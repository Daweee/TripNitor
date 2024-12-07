import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../models/is_water_model.dart';
import '../services/is_water_service.dart';

final isWaterProvider =
    StateNotifierProvider<IsWaterNotifier, IsWaterState>((ref) {
  return IsWaterNotifier(IsWaterService());
});

class IsWaterNotifier extends StateNotifier<IsWaterState> {
  final IsWaterService _service;

  IsWaterNotifier(this._service) : super(IsWaterState());

  Future<void> checkLocation(LatLng coordinates) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final isWater = await _service.isWater(coordinates);
      state = state.copyWith(isLoading: false, isWater: isWater);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
