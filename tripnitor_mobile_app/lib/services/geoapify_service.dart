import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/constant.dart';
import '../models/reverse_geocode_response_model.dart';
import '../models/route_response_model.dart';

class GeoapifyService {
  static final GeoapifyService _instance = GeoapifyService._internal();
  factory GeoapifyService() => _instance;
  late final Dio _dio;
  static const int _connectTimeout = 15;
  static const int _receiveTimeout = 10;

  GeoapifyService._internal() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: GeoApifyConfig.BASE_URL,
      connectTimeout: Duration(seconds: _connectTimeout),
      receiveTimeout: Duration(seconds: _receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  Future<ReverseGeocodeResponseModel> getAddressFromLatLng(
      LatLng position) async {
    try {
      final response = await _dio.get(
        '/geocode/reverse',
        queryParameters: {
          'lat': position.latitude,
          'lon': position.longitude,
          'format': 'json',
          'apiKey': GeoApifyConfig.REVERSE_GEOCODING_API_KEY,
        },
      );

      final results = response.data['results'] as List<dynamic>;

      if (results.isEmpty) {
        throw Exception('No results found for the given coordinates');
      }

      return ReverseGeocodeResponseModel.fromJson(results.first);
    } on DioException catch (e) {
      throw Exception(
        'Failed to fetch address: $e',
      );
    } catch (e) {
      throw Exception('Unexpected error occurred');
    }
  }

  Future<RouteResponseModel> getRoute(List<LatLng> locations) async {
    try {
      final waypoints = locations
          .map((location) => '${location.latitude},${location.longitude}')
          .join('|');

      final response = await _dio.get(
        '/routing',
        queryParameters: {
          'waypoints': waypoints,
          'mode': 'drive',
          'apiKey': GeoApifyConfig.ROUTING_API_KEY,
        },
      );

      if (response.statusCode == 200) {
        if (response.data['features'] != null &&
            response.data['features'].isNotEmpty) {
          return RouteResponseModel.fromJson(response.data['features'][0]);
        } else {
          throw Exception('No route found between the specified locations');
        }
      } else {
        throw Exception('Failed to fetch route: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to fetch route: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while fetching route: $e');
    }
  }
}
