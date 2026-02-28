import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<Response> login(String email, String password) async {
    return await _dio.post(
      '/login/',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register({
    required String username,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    return await _dio.post(
      '/register/',
      data: {
        'username': username,
        'email': email,
        'password': password,
        if (referralCode != null) 'referral_code': referralCode,
      },
    );
  }

  Future<Response> verify2FA(String code) async {
    return await _dio.post('/2fa/verify/', data: {'code': code});
  }

  Future<Response> verifyEmail(String code) async {
    return await _dio.post('/verify-email/', data: {'code': code});
  }

  Future<Response> requestPasswordReset(String email) async {
    return await _dio.post('/password/reset/', data: {'email': email});
  }

  Future<Response> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    return await _dio.post(
      '/password/change/',
      data: {'current_password': currentPassword, 'new_password': newPassword},
    );
  }
}
