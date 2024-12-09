import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'token_service.dart';

class LocationService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  LocationService() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _tokenService.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<bool> isWithinBoundary(LatLng coordinates) async {
    try {
      final response = await _dio.get(
          '${HTTPConstants.BASE_URL}api/locations/check-coordinates/',
          queryParameters: {
            'lat': coordinates.latitude,
            'lng': coordinates.longitude,
          });

      if (response.statusCode == 200) {
        return response.data['data'];
      }
      return false;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
