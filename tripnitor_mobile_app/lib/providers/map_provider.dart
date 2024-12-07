import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_service_data_model.dart';
import '../services/map_service.dart';

class MapStateNotifier extends StateNotifier<LocationServiceState> {
  final MapService _mapService;

  MapStateNotifier(this._mapService)
      : super(LocationServiceState(locationServiceList: []));

  Future<void> searchLocations(
    String query,
    String? language,
    String? country,
    String? proximity,
    String? bbox,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final locationServiceList = await _mapService.searchLocations(
          query, language, country, proximity, bbox);
      state = state.copyWith(
        isLoading: false,
        locationServiceList: locationServiceList,
        message: 'Search location list results retrieved successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to retrieve search location list results: $e',
      );
    }
  }

  void clearSearchResults() {
    state = state.copyWith(locationServiceList: []);
  }
}

final mapServiceProvider = Provider<MapService>((ref) {
  return MapService();
});

final mapStateProvider =
    StateNotifierProvider<MapStateNotifier, LocationServiceState>((ref) {
  final mapService = ref.watch(mapServiceProvider);
  return MapStateNotifier(mapService);
});
