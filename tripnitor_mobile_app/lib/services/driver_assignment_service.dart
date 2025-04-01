import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:tripnitor_mobile_app/core/network/dio_client.dart';
import 'package:tripnitor_mobile_app/models/driver_assignment.dart';
import 'package:tripnitor_mobile_app/models/driver_model.dart';

class DriverAssignmentService {
  final Dio _dio = DioClient.instance;

  Future<List<DriverAssignment>> getAllDriverAssignedBookings() async {
    try {
      final response = await _dio.get('api/drivers-assignment/by-driver/');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'];

        if (dynamicData == null) {
          return [];
        }

        if (dynamicData is List) {
          final List<Map<String, dynamic>> data =
              dynamicData.whereType<Map<String, dynamic>>().toList();

          return data.map((json) => DriverAssignment.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load list of driver bookings. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load driver bookings list: ${e.message}');
    }
  }

  Future<List<DriverAssignment>> getAllSpecificDriverBookings(
      String driverId) async {
    try {
      final response = await _dio.get('api/driver-assignments/$driverId/');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'] as List<dynamic>;

        final List<Map<String, dynamic>> data =
            dynamicData.whereType<Map<String, dynamic>>().toList();
        return data.map((json) => DriverAssignment.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load list of driver bookings. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load driver bookings list: ${e.message}');
    }
  }

  Future<List<DriverAssignment>> getActiveDriverBookingsList() async {
    try {
      final response =
          await _dio.get('api/drivers-assignment/by-driver/active/');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'];

        if (dynamicData == null) {
          return [];
        }

        if (dynamicData is List) {
          final List<Map<String, dynamic>> data =
              dynamicData.whereType<Map<String, dynamic>>().toList();

          return data.map((json) => DriverAssignment.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load list of driver bookings. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to load confirmed driver bookings list: ${e.message}');
    }
  }

  Future<List<Driver>> getAvailableDriversForSwap(
      String bookingId, DateTime startDate, DateTime endDate) async {
    try {
      final Map<String, dynamic> queryParams = {};

      queryParams['booking_id'] = bookingId;
      queryParams['start_date'] = startDate;
      queryParams['end_date'] = endDate;

      final response = await _dio.get(
        'api/driver-assignment/available-for-swap/',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> driversJson = response.data['data'];
        return driversJson.map((json) => Driver.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load available drivers');
      }
    } catch (e) {
      throw Exception('Error getting available drivers: $e');
    }
  }
}
