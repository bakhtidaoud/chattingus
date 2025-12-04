import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import 'token_storage_service.dart';

class AuthService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final TokenStorageService _tokenService = Get.find<TokenStorageService>();

  final RxBool isLoggedIn = false.obs;

  Future<bool> checkAuthState() async {
    final token = await _tokenService.getAccessToken();
    if (token != null) {
      isLoggedIn.value = true;
      return true;
    }
    isLoggedIn.value = false;
    return false;
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/token/',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];
        await _tokenService.saveTokens(accessToken, refreshToken);
        isLoggedIn.value = true;
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  /// Register a new user
  /// POST /users/register/
  /// Required fields: username, email, password, password2, first_name, last_name, phone_number
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        '/users/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password2': password2,
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registration successful
        // Optionally auto-login here if the backend returns tokens on register
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _tokenService.clearTokens();
    isLoggedIn.value = false;
    // Navigate to login screen
    // Get.offAllNamed('/login');
    // Assuming '/login' is the route name. If not, the user can configure it later.
  }
}
