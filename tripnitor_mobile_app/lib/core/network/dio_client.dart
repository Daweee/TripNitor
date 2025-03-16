import 'package:dio/dio.dart';
import '../../services/token_service.dart';
import '../constants/constant.dart';

class DioClient {
  static Dio? _dio;
  static final TokenService _tokenService = tokenService;

  static Dio get instance {
    if (_dio == null) {
      final baseUrl = HTTPConstants.BASE_URL;
      if (baseUrl == null) {
        throw Exception('Base URL is not configured');
      }

      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final accessToken = await _tokenService.getAccessToken();
            if (accessToken != null) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            }
            return handler.next(options);
          },
          onError: (error, handler) async {
            if (error.response?.statusCode == 401) {
              try {
                final newAccessToken = await _tokenService.getNewAccessToken();

                error.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                return handler.resolve(await _dio!.fetch(error.requestOptions));
              } catch (e) {
                await _tokenService.deleteTokens();
                return handler.next(error);
              }
            }
            return handler.next(error);
          },
        ),
      );
    }
    return _dio!;
  }

  static void reset() {
    _dio = null;
  }
}
