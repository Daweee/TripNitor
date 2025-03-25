import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/core/network/dio_client.dart';
import 'package:tripnitor_mobile_app/models/booking_leg_model.dart';

class BookingLegService {
  final Dio _dio = DioClient.instance;

  Future<BookingLeg> activateBookingLeg(int bookingLegId) async {
    try {
      final response =
          await _dio.patch('api/booking-legs/$bookingLegId/to-active/');

      if (response.statusCode == 200) {
        return BookingLeg.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to confirm booking: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to confirm booking: ${e.message}');
    }
  }

  Future<BookingLeg> completeBookingLeg(int bookingLegId) async {
    try {
      final response =
          await _dio.patch('api/booking-legs/$bookingLegId/to-complete/');

      if (response.statusCode == 200) {
        return BookingLeg.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to confirm booking: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to confirm booking: ${e.message}');
    }
  }
}
