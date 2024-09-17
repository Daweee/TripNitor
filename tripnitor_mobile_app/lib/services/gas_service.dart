import 'package:dio/dio.dart';
import '../constants/constant.dart';
import '../models/gas_model.dart';
import 'token_service.dart';

class GasService {
  final Dio _dio = Dio();
  final TokenService _tokenService = TokenService();

  GasService() {
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

  Future<List<Gas>> getGasList() async {
    try {
      final response = await _dio.get('${HTTPConstants.BASE_URL}api/gas/');
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>?;
        final dynamicData = responseData?['data'] as List<dynamic>;

        final List<Map<String, dynamic>> data =
            dynamicData.whereType<Map<String, dynamic>>().toList();

        return data.map((json) => Gas.fromJson(json)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load list of gas. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load gas list: ${e.message}');
    }
  }

  Future<Gas> getGasDetail(String gasId) async {
    try {
      final response =
          await _dio.get('${HTTPConstants.BASE_URL}api/gas/$gasId/');

      if (response.statusCode == 200) {
        final gasData = response.data['data'];
        return Gas.fromJson(gasData);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load gas details. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to load gasdetails: ${e.message}');
    }
  }

  Future<Gas> createGas(Gas gas) async {
    try {
      final response = await _dio.post(
        '${HTTPConstants.BASE_URL}api/gas/register/',
        data: gas.toJson(),
      );

      if (response.statusCode == 201) {
        return Gas.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to create gas. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to create gas: ${e.message}');
    }
  }

  Future<void> deleteGas(String gasId) async {
    try {
      final response =
          await _dio.delete('${HTTPConstants.BASE_URL}api/gas/$gasId/delete/');

      if (response.statusCode == 204) {
        return;
      } else {
        throw Exception(
            'Failed to delete gas with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to delete gas: ${e.message}');
    }
  }

  Future<void> updateGas(String gasId, Gas gas) async {
    try {
      final response = await _dio.put(
        '${HTTPConstants.BASE_URL}api/vans/$gasId/update/',
        data: gas.toJson(),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to update gas: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to update gas: ${e.message}');
    }
  }
}
