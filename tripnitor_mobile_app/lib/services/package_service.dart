import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/core/network/dio_client.dart';
import '../models/package_model.dart';

class PackageService {
  final Dio _dio = DioClient.instance;

  Future<List<Package>> getAllPackages() async {
    try {
      final response = await _dio.get('api/packages/');

      if (response.statusCode == 200) {
        return (response.data['data'] as List)
            .map((json) => Package.fromJson(json))
            .toList();
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
      final response = await _dio.get('api/packages/$packageId/');
      if (response.statusCode == 200) {
        return Package.fromJson(response.data['data']);
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
      final response = await _dio.post(
        'api/packages/register/',
        data: package.toJson(),
      );

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
      final response = await _dio.post(
        'api/packages/calculate-fare/',
        data: {'total_distance': totalDistance},
      );

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
    try {
      final response = await _dio.patch(
        'api/packages/$packageId/update/',
        data: package.toJson(),
      );

      if (response.data['data'] != null) {
        return Package.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update package: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update package: ${e.message}');
    }
  }
}
