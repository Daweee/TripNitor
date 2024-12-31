import 'dart:developer';

import 'package:dio/dio.dart';
import '../core/constants/constant.dart';
import '../models/package_model.dart';
import 'token_service.dart';

class PackageService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  PackageService() {
    _setupInterceptors();
    _setupDioConfig();
  }

  void _setupDioConfig() {
    _dio.options.validateStatus = (status) {
      return status != null && status >= 200 && status < 300;
    };
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

      if (response.data['data'] != null) {
        final createdPackage = Package.fromJson(response.data['data']);
        return createdPackage;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to create package. No data in response.',
      );
    } on DioException catch (e) {
      if (e.response?.data?['data'] != null) {
        try {
          final createdPackage = Package.fromJson(e.response!.data['data']);

          return createdPackage;
        } catch (parseError) {
          rethrow;
        }
      }
      rethrow;
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

  Future<Package> updatePackage(PackageCreate package, String packageId) async {
    final data = package.toJson();

    try {
      final response = await _dio.patch(
          '${HTTPConstants.BASE_URL}api/packages/$packageId/update/',
          data: data);

      if (response.data['data'] != null) {
        final updatedPackage = Package.fromJson(response.data['data']);
        return updatedPackage;
      } else {
        throw Exception('Failed to update package: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update package: ${e.message}');
    }
  }
}
