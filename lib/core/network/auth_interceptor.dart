import 'package:dio/dio.dart';
import 'package:get/get.dart'
    as get_x; // Alias to avoid conflict if needed, though not strictly necessary here
import 'package:flutter/foundation.dart';
import '../services/token_storage_service.dart';
import '../services/error_logging_service.dart';
import '../services/error_dialog_service.dart';
import '../constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorageService _tokenService =
      get_x.Get.find<TokenStorageService>();
  final Dio _dio;

  AuthInterceptor(this._dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Log error
    try {
      final errorLoggingService = get_x.Get.find<ErrorLoggingService>();
      errorLoggingService.logError(
        message: 'API Error: ${err.message}',
        screen: 'API Client',
        context: {
          'url': err.requestOptions.path,
          'method': err.requestOptions.method,
          'status_code': err.response?.statusCode,
        },
      );
    } catch (e) {
      debugPrint('Failed to log API error: $e');
    }

    if (err.response?.statusCode == 401) {
      // If the error is 401, try to refresh the token
      final refreshToken = await _tokenService.getRefreshToken();

      if (refreshToken != null) {
        try {
          debugPrint('🔄 Attempting token refresh...');

          // Create a new Dio instance to avoid circular dependency/interceptor loops
          final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

          final response = await refreshDio.post(
            '/token/refresh/',
            data: {'refresh': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access'];
            final newRefreshToken = response.data['refresh'] ?? refreshToken;

            await _tokenService.saveTokens(newAccessToken, newRefreshToken);

            debugPrint('✅ Token refreshed successfully');

            // Retry the original request with the new token
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';

            final clonedRequest = await _dio.request(
              opts.path,
              options: Options(
                method: opts.method,
                headers: opts.headers,
                extra: opts.extra,
                responseType: opts.responseType,
                contentType: opts.contentType,
                validateStatus: opts.validateStatus,
                receiveTimeout: opts.receiveTimeout,
                sendTimeout: opts.sendTimeout,
              ),
              data: opts.data,
              queryParameters: opts.queryParameters,
              cancelToken: opts.cancelToken,
              onReceiveProgress: opts.onReceiveProgress,
            );

            return handler.resolve(clonedRequest);
          }
        } catch (e) {
          debugPrint('❌ Token refresh failed: $e');
          // Refresh failed
          await _logout();
        }
      } else {
        // No refresh token available
        await _logout();
      }
    }

    return handler.next(err);
  }

  Future<void> _logout() async {
    await _tokenService.clearTokens();

    // Show auth error dialog
    try {
      final errorDialogService = get_x.Get.find<ErrorDialogService>();
      errorDialogService.showAuthError();
    } catch (e) {
      debugPrint('Failed to show auth error dialog: $e');
    }

    debugPrint('Session expired. Please login again.');
    // Navigate to login screen
    // get_x.Get.offAllNamed('/login'); // Uncomment and adjust route when available
  }
}
