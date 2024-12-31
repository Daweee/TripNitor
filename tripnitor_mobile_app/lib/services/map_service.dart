import 'package:dio/dio.dart';
import '../core/constants/constant.dart';
import '../models/location_service_data_model.dart';

class MapService {
  late final Dio _dio;

  MapService() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      queryParameters: {
        'access_token': MapboxConfig.API_KEY,
        'session_token': '',
      },
    ));
  }

  Future<List<LocationServiceData>> searchLocations(String query,
      String? language, String? country, String? proximity, String? bbox,
      {Duration delay = const Duration(seconds: 3)}) async {
    try {
      await Future.delayed(delay);

      final response = await _dio.get(
        '${MapboxConfig.SEARCH_BASE_URL}/suggest',
        queryParameters: {
          'q': query,
          if (language != null) 'language': language,
          if (country != null) 'country': country,
          if (proximity != null) 'proximity': proximity,
          if (bbox != null) 'bbox': bbox,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> suggestions = response.data['suggestions'];

        List<LocationServiceData> locationServices =
            suggestions.map((suggestion) {
          if (suggestion is Map<String, dynamic>) {
            return LocationServiceData.fromJson(suggestion);
          } else {
            throw Exception(
                'Suggestion is not a Map<String, dynamic>: $suggestion');
          }
        }).toList();

        return locationServices;
      } else {
        throw Exception(
            'MapBox API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LocationServiceData> getLocationData(
    String mapboxId,
  ) async {
    try {
      final response = await _dio.get(
        '${MapboxConfig.SEARCH_BASE_URL}/retrieve/$mapboxId',
      );

      if (response.statusCode == 200) {
        final selectedLocationData = response.data['features'][0]['properties'];
        return LocationServiceData.fromJson(selectedLocationData);
      } else {
        throw Exception(
            'MapBox API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
