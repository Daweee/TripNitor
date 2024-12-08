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
        List<dynamic> data = response.data['data'];
        return data.map((json) => Package.fromJson(json)).toList();
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

  Future<Package> fetchPackageDetails(String packageId) async {
    try {
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/packages/$packageId/');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data['data'];
        return Package.fromJson(data);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load package details. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load package details: ${e.message}');
    }
  }

  Future<Package> createPackage(PackageCreate package) async {
    try {
      final data = package.toJson();

      final response = await _dio
          .post('${HTTPConstants.BASE_URL}api/packages/register/', data: data);

      if (response.statusCode == 201) {
        return Package.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create package. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<double> calculatePackageFare(double totalDistance) async {
    try {
      final data = {'total_distance': totalDistance};

      final response = await _dio.post(
          '${HTTPConstants.BASE_URL}api/packages/calculate-fare/',
          data: data);

      if (response.statusCode == 200) {
        return response.data['data']['fare'];
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to calculate package fare. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
