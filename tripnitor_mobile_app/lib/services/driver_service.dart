import 'package:dio/dio.dart';
import '../constants/constant.dart';
import '../models/driver_model.dart';
import 'token_service.dart';

class DriverService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  DriverService() {
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

  Future<Driver> getDriverDetail(String driverId) async {
    try {
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/drivers/$driverId/');

      if (response.statusCode == 200) {
        final driverData = response.data['data'];
        return Driver.fromJson(driverData);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load driver details. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load driver details: ${e.message}');
    }
  }

  Future<List<Driver>> getDriverList() async {
    try {
      final response = await _dio.get('${HTTPConstants.BASE_URL}api/drivers/');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'] as List<dynamic>;

        final List<Map<String, dynamic>> data =
            dynamicData.whereType<Map<String, dynamic>>().toList();
        return data.map((json) => Driver.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load list of drivers. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load driver list: ${e.message}');
    }
  }

  Future<Driver> createDriver(Driver driver) async {
    try {
      final response = await _dio.post(
        '${HTTPConstants.BASE_URL}api/drivers/register/',
        data: driver.toJson(),
      );

      if (response.statusCode == 201) {
        return Driver.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create driver. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to create driver: ${e.message}');
    }
  }

  Future<void> deleteDriver(String driverId) async {
    try {
      final response = await _dio
          .delete('${HTTPConstants.BASE_URL}api/drivers/$driverId/delete/');

      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception(
            'Failed to delete driver with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete driver: ${e.message}');
    }
  }

  Future<void> updateDriver(String driverId, Driver driver) async {
    try {
      final response = await _dio.put(
        '${HTTPConstants.BASE_URL}api/drivers/$driverId/update/',
        data: driver.toJson(),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to update driver: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update driver: ${e.message}');
    }
  }
}
