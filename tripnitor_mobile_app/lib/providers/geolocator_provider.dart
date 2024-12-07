import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/geolocator_model.dart';
import '../services/geolocator_service.dart';

class GeolocatorStateNotifier extends StateNotifier<GeolocatorState> {
  final GeolocatorService _geolocatorService;

  GeolocatorStateNotifier(this._geolocatorService) : super(GeolocatorState());

  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true);
    try {
      final position = await _geolocatorService.getCurrentLocation();
      state = state.copyWith(position: position, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final geolocatorServiceProvider = Provider<GeolocatorService>((ref) {
  return GeolocatorService();
});

final geolocatorStateProvider =
    StateNotifierProvider<GeolocatorStateNotifier, GeolocatorState>((ref) {
  final geolocatorService = ref.watch(geolocatorServiceProvider);
  return GeolocatorStateNotifier(geolocatorService);
});
