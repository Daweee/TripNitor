import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/constant.dart';
import '../models/gas_model.dart';
import 'token_service.dart';

class IsWaterService {
  late final Dio _dio;

  IsWaterService() {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      queryParameters: {
        'rapidapi-key': IsItWaterConfig.API_KEY,
      },
    ));
  }

  Future<bool> isWater(LatLng coordinate) async {
    try {
      final response = await _dio.get(
        IsItWaterConfig.ISITWATER_BASE_URL,
        queryParameters: {
          'latitude': coordinate.latitude,
          'longitude': coordinate.longitude,
        },
      );

      if (response.statusCode == 200) {
        return response.data['water'];
      }
      return false;
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
