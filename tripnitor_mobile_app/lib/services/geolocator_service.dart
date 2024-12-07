import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  GeolocatorService() {}
  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings);

      return position;
    } catch (e) {
      throw Exception('$e');
    }
  }
}
