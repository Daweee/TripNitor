import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:tripnitor_mobile_app/core/network/dio_client.dart';

class LocationService {
  final Dio _dio = DioClient.instance;

  Future<bool> isWithinBoundary(LatLng coordinates) async {
    try {
      final response =
          await _dio.get('api/locations/check-coordinates/', queryParameters: {
        'lat': coordinates.latitude,
        'lng': coordinates.longitude,
      });

      if (response.statusCode == 200) {
        return response.data['data']['is_within_boundary'];
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isWithinNorthCebuBoundary(
      LatLng coordinates, String region) async {
    try {
      final response =
          await _dio.get('api/locations/check-coordinates/', queryParameters: {
        'lat': coordinates.latitude,
        'lng': coordinates.longitude,
        'region': region,
      });

      if (response.statusCode == 200) {
        return response.data['data']['is_within_boundary'];
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isWithinSouthCebuBoundary(
      LatLng coordinates, String region) async {
    try {
      final response =
          await _dio.get('api/locations/check-coordinates/', queryParameters: {
        'lat': coordinates.latitude,
        'lng': coordinates.longitude,
        'region': region,
      });

      if (response.statusCode == 200) {
        return response.data['data']['is_within_boundary'];
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isWithinCityCebuBoundary(
      LatLng coordinates, String region) async {
    try {
      final response =
          await _dio.get('api/locations/check-coordinates/', queryParameters: {
        'lat': coordinates.latitude,
        'lng': coordinates.longitude,
        'region': region,
      });

      if (response.statusCode == 200) {
        return response.data['data']['is_within_boundary'];
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> isAllMarkersInRegion(List<LatLng> markers, String region) async {
    final data = {
      'coordinates':
          markers.map((marker) => [marker.latitude, marker.longitude]).toList(),
      'region': region
    };
    try {
      final response =
          await _dio.post('api/locations/check-coordinates/', data: data);

      if (response.statusCode == 200) {
        return response.data['data']['all_within_boundary'] ?? false;
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
