import 'package:dio/dio.dart';
import 'api_config.dart';
import 'token_storage.dart';

/// Thin envelope the backend wraps every response in:
/// `{ success, data, message }`. Unwrap `data` at the call site.
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.instance.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final alreadyRetried =
              error.requestOptions.extra['retried'] == true;

          if (isUnauthorized && !alreadyRetried) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              final retryOptions = error.requestOptions;
              retryOptions.extra['retried'] = true;
              final newToken = await TokenStorage.instance.getAccessToken();
              retryOptions.headers['Authorization'] = 'Bearer $newToken';
              try {
                final response = await _dio.fetch(retryOptions);
                return handler.resolve(response);
              } catch (_) {
                // fall through to original error below
              }
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;

  Dio get dio => _dio;

  Future<bool> _tryRefreshToken() async {
    final refreshToken = await TokenStorage.instance.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      // Bare Dio instance — bypasses interceptors to avoid a refresh loop.
      final response = await Dio(
        BaseOptions(baseUrl: ApiConfig.baseUrl),
      ).post('/auth/refresh', data: {'refreshToken': refreshToken});

      final data = response.data['data'] as Map<String, dynamic>;
      await TokenStorage.instance.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return true;
    } catch (_) {
      await TokenStorage.instance.clear();
      return false;
    }
  }
}
