import 'package:geolocator/geolocator.dart';

class GeolocatorState {
  final Position? position;
  final bool isLoading;

  GeolocatorState({this.position, this.isLoading = false});

  GeolocatorState copyWith({Position? position, bool? isLoading}) {
    return GeolocatorState(
      position: position ?? this.position,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
