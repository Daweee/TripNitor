import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/core/network/dio_client.dart';
import 'package:tripnitor_mobile_app/models/rating_model.dart';

class RatingService {
  final Dio _dio = DioClient.instance;

  Future<Rating> submitRating(
      String bookingId, String userId, int rating, String? comment) async {
    final data = RatingCreate(
        booking: bookingId, user: userId, rating: rating, comment: comment);
    try {
      final response = await _dio.post(
        'api/ratings/register/',
        data: data.toJson(),
      );

      if (response.statusCode == 201) {
        return Rating.fromJson(response.data['data']);
      }
      throw Exception('Failed to submit rating: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorMessage = e.response?.data['message'] ?? 'An error occurred';
        if (statusCode == 400) {
          throw Exception(errorMessage);
        } else {
          throw Exception('An unexpected error occurred');
        }
      } else {
        throw Exception('No response from server');
      }
    }
  }
}
