import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constant.dart';
import '../models/auth_model.dart';
import '../providers/auth_provider.dart';
import 'token_service.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await tokenService.getAccessToken();
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response =
          await _dio.post('${HTTPConstants.BASE_URL}api/users/login/', data: {
        'username': username,
        'password': password,
      });
      await _saveTokens(response.data['data']);
      return response.data['data'];
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

  Future<Map<String, dynamic>> register(String username, String name,
      String email, String phoneNumber, String password) async {
    try {
      final response = await _dio
          .post('${HTTPConstants.BASE_URL}api/users/register/', data: {
        'username': username,
        'name': name,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
      });

      if (response.statusCode == 201) {
        return await login(username, password);
      }

      return response.data;
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<Map<String, dynamic>> logout(String refreshToken) async {
    try {
      final response =
          await _dio.post('${HTTPConstants.BASE_URL}api/users/logout/', data: {
        'refresh': refreshToken,
      });
      await tokenService.deleteTokens();
      return {};
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(String userId) async {
    try {
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/users/$userId/');
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load user details. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    await tokenService.saveTokens(
        data['id'], data['token']['access'], data['token']['refresh']);
  }
}
