import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../models/route_response_model.dart';
import '../services/geoapify_service.dart';

class RoutePolylineNotifier extends StateNotifier<RouteState> {
  final GeoapifyService _geoapifyService;

  RoutePolylineNotifier(this._geoapifyService) : super(RouteState());

  Future<void> getRoute(List<LatLng> markerCoordinates) async {
    state = state.copyWith(
      route: null,
      isLoading: true,
      error: null,
      totalDistance: null,
    );

    try {
      final route = await _geoapifyService.getRoute(markerCoordinates);
      state = state.copyWith(
        isLoading: false,
        route: route,
        totalDistance:
            double.parse((route.totalDistance / 1000).toStringAsFixed(2)),
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        route: null,
        error: 'Failed to load route: $e',
      );
    }
  }

  void clearRoute() {
    state = RouteState();
  }
}

final routeServiceProvider = Provider<GeoapifyService>((ref) {
  return GeoapifyService();
});

final routeStateProvider =
    StateNotifierProvider<RoutePolylineNotifier, RouteState>((ref) {
  final routeService = ref.watch(routeServiceProvider);
  return RoutePolylineNotifier(routeService);
});
