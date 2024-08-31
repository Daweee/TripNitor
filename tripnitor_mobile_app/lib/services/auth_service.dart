import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constant.dart';
import '../models/auth_model.dart';
import '../providers/auth_provider.dart';
import 'token_service.dart';

class AuthService {
    final Dio _dio = Dio();

    Future<Map<String, dynamic>> login(String username, String password) async {
        try {
            final response = await _dio.post('${HTTPConstants.BASE_URL}api/users/login/', 
                data: {
                'username': username,
                'password': password,
                });
            await tokenService.saveTokens(
                response.data['data']['user']['id'],
                response.data['data']['token']['access'],
                response.data['data']['token']['refresh']
            );
            return response.data;
        } catch (e) {
            throw Exception('Failed to login: $e');
        }
    }

    Future<Map<String, dynamic>> register(String username, String name, String email, String phoneNumber, String password) async {
        try {
            final response = await _dio.post('${HTTPConstants.BASE_URL}api/users/register/',
            data: {
                'username': username,
                'name': name,
                'email': email,
                'phone_number': phoneNumber,
                'password': password,
            });
            return response.data;
        } catch (e) {
            throw Exception('Failed to register: $e');
        }
    }

    Future<Map<String, dynamic>> logout(String refreshToken) async {
        try {
            final response = await _dio.post('${HTTPConstants.BASE_URL}api/users/logout/',
            data: {
                'refresh': refreshToken,
            });
            return {};
        } catch (e) {
            throw Exception('Failed to logout: $e');
        }
    }
}


        
    
