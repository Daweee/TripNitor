import 'package:dio/dio.dart';
import '../../../../core/config/config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/auth_token_model.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
    /// Attempts to log in a user with the provided credentials using api endpoint.
    /// 
    /// Throws a [ServerException] for all error codes.
    Future<AuthResponseModel> loginUser({required String username, required String password,});
    
    /// Attempts to register a new user with the provided information using api endpoint.
    /// 
    /// Throws a [ServerException] for all error codes.
    Future<AuthResponseModel> registerUser({
        required String username,
        required String email,
        required String password,
        required String name,
        required String phoneNumber,
    });

    /// Logs out the currently authenticated user using api endpoint.
    /// 
    /// Throws a [ServerException] for all error codes.
    Future<AuthResponseModel> logoutUser({required String token});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
    final Dio dio;

    AuthRemoteDataSourceImpl({required this.dio}) {
        dio.options.baseUrl = Config.baseUrl;
        dio.options.headers = {'Content-Type': 'application/json'};
    }

    @override
    Future<AuthResponseModel> loginUser({required String username, required String password}) async {
        try { 
            final response = await dio.post(
                'api/users/login',
                data: {
                    'username': username,
                    'password': password,
                },
            );
            return AuthResponseModel.fromJson(response.data);
        } on DioException catch (e) {
            throw ServerException(
                message: e.response?.data['message'] ?? 'Failed to login',
            );
        }
    }

    @override
    Future<AuthResponseModel> logoutUser({required String token}) async {
        try {
            final response = await dio.post(
                'api/users/logout',
                options: Options(headers: {'Authorization': 'Bearer $token'}),
            );
                
            if (response.statusCode == 200 || response.statusCode == 205) {
                return AuthResponseModel(
                    status: response.statusCode ?? 200,
                    user: const AuthUserModel(
                        username: '',
                        name: '',
                        email: '',
                        phoneNumber: '',
                    ),
                    token: const AuthTokenModel(access: '', refresh: ''),
                    message: response.data['message'] ?? 'Successfully logged out',
                );
            } else {
                throw ServerException(
                    message: response.data['message'] ?? 'Failed to logout',
                );
            }
        } on DioException catch (e) {
            throw ServerException(
                message: e.response?.data['message'] ?? 'Failed to logout',
            );
        }
    }

    @override
    Future<AuthResponseModel> registerUser({required String username, required String email, required String password, required String name, required String phoneNumber}) async {
        try {
            final response = await dio.post(
                '/api/users/signup',
                data: {
                    'username': username,
                    'email': email,
                    'password': password,
                    'name': name,
                    'phone_number': phoneNumber,
                },
            );
            return AuthResponseModel.fromJson(response.data);
        } on DioException catch (e) {
            throw ServerException(
                message: e.response?.data['message'] ?? 'Failed to register',
            );
        }
    }
}