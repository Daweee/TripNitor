import 'package:dio/dio.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import '../models/van_model.dart';
import 'token_service.dart';

class VanService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  VanService() {
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

  Future<List<Van>> getVanList() async {
    try {
      final response = await _dio.get('${HTTPConstants.BASE_URL}api/vans/');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'] as List<dynamic>;

        final List<Map<String, dynamic>> data =
            dynamicData.whereType<Map<String, dynamic>>().toList();

        return data.map((json) => Van.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load list of drivers. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load driver list: ${e.message}');
    }
  }

  Future<List<Van>> getUnassignedVanList() async {
    try {
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/vans/unassigned/');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'] as List<dynamic>;

        final List<Map<String, dynamic>> data =
            dynamicData.whereType<Map<String, dynamic>>().toList();

        return data.map((json) => Van.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load list of drivers. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load driver list: ${e.message}');
    }
  }

  Future<Van> getVanDetail(String vanId) async {
    try {
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/vans/$vanId/');

      if (response.statusCode == 200) {
        final vanData = response.data['data'];
        return Van.fromJson(vanData);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error:
              'Failed to load driver details. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load van details: ${e.message}');
    }
  }

  Future<Van> createVan(VanPatch vanPatch) async {
    try {
      final response = await _dio.post(
        '${HTTPConstants.BASE_URL}api/vans/register/',
        data: vanPatch.toJson(),
      );

      if (response.statusCode == 201) {
        return Van.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create van. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to create van: ${e.message}');
    }
  }

  Future<void> deleteVan(String vanId) async {
    try {
      final response =
          await _dio.delete('${HTTPConstants.BASE_URL}api/vans/$vanId/delete/');

      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception(
            'Failed to delete van with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete van: ${e.message}');
    }
  }

  Future<Van> updateVan(String vanId, VanPatch van) async {
    try {
      final response = await _dio.put(
        '${HTTPConstants.BASE_URL}api/vans/$vanId/update/',
        data: van.toJson(),
      );

      if (response.statusCode == 200) {
        return Van.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to update van: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update van: ${e.message}');
    }
  }
}
