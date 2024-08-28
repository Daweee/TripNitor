import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constant.dart';
import '../models/auth_model.dart';
import '../providers/auth_provider.dart';

class AuthService {
    final Dio _dio = Dio();

    Future<Map<String, dynamic>> login(String username, String password) async {
        try {
            final response = await _dio.post('${HTTPConstants.BASE_URL}api/users/login/', 
            data: {
                'username': username,
                'password': password,
                });
                return response.data;
            } catch (e) {
                throw Exception('Failed to login: $e');
            }
        }
    }

        
    
