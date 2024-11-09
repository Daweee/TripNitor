import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/constants/constant.dart';
import 'package:tripnitor_mobile_app/models/driver_assignment.dart';
import 'token_service.dart';

class DriverAssignmentService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  DriverAssignmentService() {
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

  Future<List<DriverAssignment>> getAllDriverAssignedBookings() async {
    try {
      final response = await _dio
          .get('${HTTPConstants.BASE_URL}api/drivers-assignment/by-driver/');
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
      final response = await _dio
          .get('${HTTPConstants.BASE_URL}api/driver-assignments/$driverId/');

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
      final response = await _dio.get(
          '${HTTPConstants.BASE_URL}api/drivers-assignment/by-driver/active/');
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
}
