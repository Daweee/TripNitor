import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveTokens(String id, String accessToken, String refreshToken) async {
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
}

final tokenService = TokenService();