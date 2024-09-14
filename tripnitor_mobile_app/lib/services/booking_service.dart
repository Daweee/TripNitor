import 'package:dio/dio.dart';
import '../constants/constant.dart';
import '../models/booking_model.dart';
import '../models/preview_boking_model.dart';
import 'token_service.dart';

class BookingService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  BookingService() {
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

  Future<PreviewBookingResponse> previewBooking(
      PreviewBookingRequest request) async {
    try {
      final response = await _dio.post(
        '${HTTPConstants.BASE_URL}api/bookings/preview-booking/',
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

  Future<Map<String, dynamic>> createBooking(
      BookingCreationRequest bookingRequest) async {
    try {
      final response = await _dio.post(
        '${HTTPConstants.BASE_URL}api/bookings/create/',
        data: bookingRequest.toJson(),
      );

      if (response.statusCode == 201) {
        return response.data['data'];
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
        '${HTTPConstants.BASE_URL}api/bookings/user-bookings/',
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
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/bookings/$bookingId/');

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
}
