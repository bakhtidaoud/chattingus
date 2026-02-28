import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Base URL should be updated to actual backend address
  static const String baseUrl = 'https://api.chattingus.com/api';

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          contentType: 'application/json',
        ),
      ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                final response = await Dio().post(
                  '$baseUrl/login/refresh/',
                  data: {'refresh': refreshToken},
                );

                final newAccessToken = response.data['access'];
                await storage.write(key: 'access_token', value: newAccessToken);

                // Retry the original request
                e.requestOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
                final clonedRequest = await dio.fetch(e.requestOptions);
                return handler.resolve(clonedRequest);
              } catch (refreshError) {
                // Refresh failed, logout user
                await storage.deleteAll();
                // Here we would ideally trigger a logout in the UI/State
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
