import 'package:dio/dio.dart';
import '../core/network/dio_client.dart';

class StripeService {
  final Dio _dio = DioClient.instance;

  Future<dynamic> createPaymentIntent(double amount, String currency) async {
    try {
      final response = await _dio.post(
        'api/payments/process/',
        data: {
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to process payment');
      }
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }
}
