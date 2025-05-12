import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/core/network/dio_client.dart';
import '../core/constants/constant.dart';
import '../models/driver_model.dart';

class DriverService {
  final Dio _dio = DioClient.instance;

  Future<Driver> getDriverDetail(String driverId) async {
    try {
      final response = await _dio.get('api/drivers/$driverId/');

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
      final response = await _dio.get('api/drivers/');
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
    String phoneNumber,
    String password,
    String licenseNumber,
    String? dateHired,
    String? vanId,
  ) async {
    try {
      final data = {
        'username': username,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'license_number': licenseNumber,
        'date_hired': dateHired,
        'van_id': vanId,
      };

      final response = await _dio.post(
        'api/drivers/register/',
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

  Future<void> deactivateDriver(String driverId) async {
    try {
      final response = await _dio.patch('api/drivers/$driverId/deactivate/',
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));

      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception(
            'Failed to deactivate driver with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to deactivate driver: ${e.message}');
    }
  }

  Future<void> reactivateDriver(String driverId) async {
    try {
      final response = await _dio.patch('api/drivers/$driverId/reactivate/',
          options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
          ));

      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception(
            'Failed to reactivate driver with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to reactivate driver: ${e.message}');
    }
  }

  Future<Driver> updateDriver(String driverId, DriverPatch driver) async {
    try {
      final response = await _dio.patch(
        'api/drivers/$driverId/update/',
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
      final response = await _dio.get('api/user-info/');

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
