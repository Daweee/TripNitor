import 'package:dio/dio.dart';
import '../constants/constant.dart';
import '../models/package_model.dart';
import 'token_service.dart';

class PackageService {
    final Dio _dio = Dio();
    final TokenService _tokenService = TokenService();

    PackageService() { 
        _setupInterceptors();
    }

    void _setupInterceptors() {
        _dio.interceptors.add(
            InterceptorsWrapper(
                onRequest: (options, handler) async {
                    final accessToken = await _tokenService.getAccessToken();
                    if (accessToken != null) {
                        options.headers['Authorization'] = 'Bearer $accessToken';
                    }
                return handler.next(options);
                },
            ),
        );
    }

    Future<List<Package>> getAllPackages() async {
        try {
            final response = await _dio.get('${HTTPConstants.BASE_URL}api/packages/');

            if (response.statusCode == 200) {
                final Map<String, dynamic> responseData = response.data;
                final Map<String, dynamic> data = responseData['data'];
                final List<dynamic> packagesJson = data['packages'] as List<dynamic>;
                return packagesJson.map((json) => Package.fromJson(json)).toList();
            } else {
                throw DioException(
                    requestOptions: response.requestOptions,
                    response: response,
                    error: 'Failed to load package list. Status: ${response.statusCode}',
                );
            }
        } on DioException catch (e) {
            throw Exception('Failed to load package list: ${e.message}');
        }
    }

    Future<Map<String, dynamic>> fetchPackageDetails(String packageId) async {
        try {
            final response = await _dio.get('${HTTPConstants.BASE_URL}api/packages/$packageId/');
            if (response.statusCode == 200) {
                return response.data['data']['package'];
            } else {
                throw DioException(
                    requestOptions: response.requestOptions,
                    response: response,
                    error: 'Failed to load package details. Status: ${response.statusCode}',
                );
            }
        } on DioException catch (e) {
            throw Exception('Failed to load package details: ${e.message}');
        }
    }
}