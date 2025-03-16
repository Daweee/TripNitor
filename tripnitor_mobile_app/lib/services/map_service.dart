import 'package:dio/dio.dart';
import '../core/constants/constant.dart';
import '../models/location_service_data_model.dart';

class MapService {
  late final Dio _dio;
  static final MapService _instance = MapService._internal();

  factory MapService() => _instance;

  MapService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: MapboxConfig.SEARCH_BASE_URL,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      queryParameters: {
        'access_token': MapboxConfig.API_KEY,
        'session_token': '',
      },
    ));
  }

  Future<List<LocationServiceData>> searchLocations(
    String query,
    String? language,
    String? country,
    String? proximity,
    String? bbox, {
    Duration delay = const Duration(seconds: 3),
  }) async {
    try {
      await Future.delayed(delay);

      final response = await _dio.get(
        '/suggest',
        queryParameters: {
          'q': query,
          if (language != null) 'language': language,
          if (country != null) 'country': country,
          if (proximity != null) 'proximity': proximity,
          if (bbox != null) 'bbox': bbox,
        },
      );

      final List<dynamic> suggestions = response.data['suggestions'];
      return suggestions
          .map((suggestion) => LocationServiceData.fromJson(suggestion))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<LocationServiceData> getLocationData(String mapboxId) async {
    final response = await _dio.get('/retrieve/$mapboxId');
    return LocationServiceData.fromJson(
        response.data['features'][0]['properties']);
  }
}
