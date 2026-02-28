import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = DioClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<Response> login(String username, String password) async {
    final response = await _dio.post(
      '/login/',
      data: {'username': username, 'password': password},
    );

    if (response.statusCode == 200) {
      await _storage.write(key: 'access_token', value: response.data['access']);
      await _storage.write(
        key: 'refresh_token',
        value: response.data['refresh'],
      );
    }
    return response;
  }

  Future<Response> getCurrentUser() async {
    return await _dio.get('/users/me/');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }
}
