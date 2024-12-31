import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/constant.dart';

class TokenService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final Dio _dio = Dio();

  Future<void> saveTokens(
      String id, String accessToken, String refreshToken) async {
    await _storage.write(key: 'id', value: id);
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'id');
  }

  Future<void> deleteTokens() async {
    await _storage.delete(key: 'id');
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<String> getNewAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    try {
      final response = await _dio.post(
        '${HTTPConstants.BASE_URL}api/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];
        await _storage.write(key: 'access_token', value: newAccessToken);
        return newAccessToken;
      }
      throw Exception('Failed to refresh token');
    } catch (e) {
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
}

final tokenService = TokenService();
