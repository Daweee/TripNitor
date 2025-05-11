import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/core/network/dio_client.dart';
import '../models/booking_model.dart';
import '../models/preview_boking_model.dart';

class BookingService {
  final Dio _dio = DioClient.instance;

  Future<PreviewBookingResponse> previewBooking(
      PreviewBookingRequest request) async {
    try {
      final response = await _dio.post(
        'api/bookings/preview-booking/',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return PreviewBookingResponse.fromJson(response.data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to preview booking. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to preview booking: ${e.message}');
    }
  }

  Future<Booking> createBooking(BookingCreationRequest bookingRequest) async {
    try {
      final response = await _dio.post(
        'api/bookings/create/',
        data: bookingRequest.toJson(),
      );

      if (response.statusCode == 201) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create booking. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to create booking: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Booking>> getUserBookings(String bookingStatus) async {
    try {
      final response = await _dio.get(
        'api/bookings/user-bookings/',
        queryParameters: {'status': bookingStatus},
      );

      if (response.statusCode == 200) {
        if (response.data == null || response.data is! Map<String, dynamic>) {
          throw Exception('Invalid response format');
        }
        final responseData = response.data as Map<String, dynamic>?;
        if (responseData == null) {
          throw Exception('Invalid response format: response.data is null');
        }

        final dynamicData = responseData['data'] as List<dynamic>;

        if (dynamicData == null) {
          throw Exception(
              'Invalid response format: "data" field is null or not a List');
        }

        final List<Map<String, dynamic>> data =
            dynamicData.whereType<Map<String, dynamic>>().toList();

        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load user bookings. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load user bookings: ${e.message}');
    }
  }

  Future<Booking> getBookingDetails(String bookingId) async {
    try {
      final response = await _dio.get('api/bookings/$bookingId/');

      if (response.statusCode == 200) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load booking details. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load booking details: ${e.message}');
    }
  }

  Future<List<Booking>> getAllBookings() async {
    try {
      final response = await _dio.get('api/bookings/');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'] as List<dynamic>;

        final List<Map<String, dynamic>> data =
            dynamicData.whereType<Map<String, dynamic>>().toList();
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load list of bookings. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load user bookings: ${e.message}');
    }
  }

  Future<Booking> confirmBooking(String bookingId) async {
    try {
      final response = await _dio.patch('api/bookings/$bookingId/confirm/');

      if (response.statusCode == 200) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to confirm booking: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to confirm booking: ${e.message}');
    }
  }

  Future<Booking> cancelBooking(String bookingId) async {
    try {
      final response = await _dio.patch('api/bookings/$bookingId/cancel/');
      if (response.statusCode == 200) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to cancel booking: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to cancel booking: ${e.message}');
    }
  }

  Future<Booking> startBooking(String bookingId) async {
    try {
      final response = await _dio.patch('api/bookings/$bookingId/start/');
      if (response.statusCode == 200) {
        return Booking.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to start booking. ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to start booking: ${e.message}');
    }
  }

  Future<bool> hasDateConflict(
      {required DateTime startDate, required DateTime endDate}) async {
    try {
      await _dio.get(
        'api/bookings/check-date-conflict/',
        queryParameters: {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        return true;
      }

      rethrow;
    }
  }
}
