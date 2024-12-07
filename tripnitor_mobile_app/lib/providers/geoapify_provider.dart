import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../models/reverse_geocode_response_model.dart';
import '../services/geoapify_service.dart';

class GeoapifyStateNotifier extends StateNotifier<ReverseGeocodeResponseState> {
  final GeoapifyService _geoapifyService;

  GeoapifyStateNotifier(this._geoapifyService)
      : super(ReverseGeocodeResponseState());

  Future<void> getAddressFromLatLng(LatLng position) async {
    state = state.copyWith(isLoading: true);
    try {
      final address = await _geoapifyService.getAddressFromLatLng(position);
      state = state.copyWith(
        isLoading: false,
        reverseGeocodeResponse: address,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}

final geoapifyServiceProvider = Provider<GeoapifyService>((ref) {
  return GeoapifyService();
});

final geoapifyStateProvider =
    StateNotifierProvider<GeoapifyStateNotifier, ReverseGeocodeResponseState>(
        (ref) {
  final geoapifyService = ref.watch(geoapifyServiceProvider);
  return GeoapifyStateNotifier(geoapifyService);
});
