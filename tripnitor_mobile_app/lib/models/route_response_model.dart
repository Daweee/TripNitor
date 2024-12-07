import 'package:latlong2/latlong.dart';

class RouteResponseModel {
  final num totalDistance;
  final List<List<LatLng>> coordinates;

  RouteResponseModel({
    required this.totalDistance,
    required this.coordinates,
  });
  factory RouteResponseModel.fromJson(Map<String, dynamic> json) {
    return RouteResponseModel(
      totalDistance: json['properties']['distance'],
      coordinates: (json['geometry']['coordinates'] as List)
          .map((coordinateList) => (coordinateList as List)
              .map((coordinate) => LatLng(coordinate[1], coordinate[0]))
              .toList())
          .toList(),
    );
  }
}

class RouteState {
  final RouteResponseModel? route;
  final bool isLoading;
  final String? error;
  final num? totalDistance;

  RouteState({
    this.route,
    this.isLoading = false,
    this.error,
    this.totalDistance,
  });

  RouteState copyWith({
    RouteResponseModel? route,
    bool? isLoading,
    String? error,
    double? totalDistance,
  }) {
    return RouteState(
      route: route ?? this.route,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }
}
