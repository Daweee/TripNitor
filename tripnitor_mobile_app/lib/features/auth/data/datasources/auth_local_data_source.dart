import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_user_model.dart';
import '../models/auth_token_model.dart';

abstract class AuthLocalDataSource {
    /// Caches the provided [AuthUserModel] data.
    /// 
    /// Throws a [CacheException] if no data is cached.
    Future<void> cacheUser(AuthUserModel user);

    /// Caches the provided [AuthTokenModel] data.
    /// 
    /// Throws a [CacheException] if no data is cached.
    Future<void> cacheToken(AuthTokenModel token);

    /// Retrieves the last cached [AuthUserModel] data.
    /// 
    /// Throws a [CacheException] if no data is cached.
    Future<AuthUserModel> getLastUser();

    /// Retrieves the last cached [AuthTokenModel] data.
    /// 
    /// Throws a [CacheException] if no data is cached.
    Future<AuthTokenModel> getLastToken();

    /// Clears all cached data.
    Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
    final SharedPreferences sharedPreferences;

    AuthLocalDataSourceImpl({required this.sharedPreferences});

    @override
    Future<void> cacheUser(AuthUserModel user) {
        return sharedPreferences.setString(
            'CACHED_USER', 
            json.encode(user.toJson()),
        );
    }
    
    @override
    Future<void> cacheToken(AuthTokenModel token) {
        return sharedPreferences.setString(
            'CACHED_TOKEN', 
            json.encode(token.toJson()),
        );
    }

    @override
    Future<void> clear() {
        return Future.wait([
            sharedPreferences.remove('CACHED_USER'),
            sharedPreferences.remove('CACHED_TOKEN'),
        ]);
    }

    @override
    Future<AuthTokenModel> getLastToken() {
        final jsonString = sharedPreferences.getString('CACHED_TOKEN');
        if (jsonString != null) {
            return Future.value(AuthTokenModel.fromJson(json.decode(jsonString)));
        } else {
            throw CacheException();
        }
    }

    @override
    Future<AuthUserModel> getLastUser() {
        final jsonString = sharedPreferences.getString('CACHED_USER');
        if (jsonString != null) {
            return Future.value(AuthUserModel.fromJson(json.decode(jsonString)));
        } else {
            throw CacheException();
        }
    }

}