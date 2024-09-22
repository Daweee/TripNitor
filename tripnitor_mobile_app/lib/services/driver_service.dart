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

  Future<DriverCreationResponse> createDriver(
    String username,
    String name,
    String email,
    String phone_number,
    String password,
    String license_number,
    String? date_hired,
    String? van_id,
  ) async {
    try {
      final data = {
        'username': username,
        'name': name,
        'email': email,
        'phone_number': phone_number,
        'password': password,
        'license_number': license_number,
        'date_hired': date_hired,
        'van_id': van_id,
      };

      final response = await _dio.post(
        '${HTTPConstants.BASE_URL}api/drivers/register/',
        data: data,
      );

      if (response.statusCode == 201) {
        return DriverCreationResponse.fromJson(response.data['data']);
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

  Future<Driver> updateDriver(String driverId, DriverPatch driver) async {
    try {
      final response = await _dio.patch(
        '${HTTPConstants.BASE_URL}api/drivers/$driverId/update/',
        data: driver.toJson(),
      );

      if (response.statusCode == 200) {
        return Driver.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update driver: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update driver: ${e.message}');
    }
  }

  Future<Driver> getUserDriverDetail() async {
    try {
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/user-info/');

      if (response.statusCode == 200) {
        return Driver.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to retrieve driver: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update driver: ${e.message}');
    }
  }
}
