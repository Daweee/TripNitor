import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/constant.dart';
import '../models/reverse_geocode_response_model.dart';
import '../models/route_response_model.dart';

class GeoapifyService {
  static final GeoapifyService _instance = GeoapifyService._internal();
  factory GeoapifyService() => _instance;
  late final Dio _dio;

  GeoapifyService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: GeoApifyConfig.BASE_URL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            throw Exception('Connection timeout. Please try again.');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<ReverseGeocodeResponseModel> getAddressFromLatLng(
      LatLng position) async {
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
  }

  Future<RouteResponseModel> getRoute(List<LatLng> locations) async {
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

    if (response.data['features']?.isEmpty ?? true) {
      throw Exception('No route found between the specified locations');
    }

    return RouteResponseModel.fromJson(response.data['features'][0]);
  }
}
