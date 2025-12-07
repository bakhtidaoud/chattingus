import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/auth_service.dart';
import '../core/services/toast_service.dart';
import '../screens/main_navigation_screen.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var keepMeLoggedIn = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ToastService.showError('Please enter email and password');
      return;
    }

    try {
      isLoading.value = true;
      debugPrint('LoginController: Attempting login with email: $email');

      await _authService.login(email, password);

      // Save "Keep Me Logged In" preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('keep_me_logged_in', keepMeLoggedIn.value);
      debugPrint(
        'LoginController: Keep me logged in saved: ${keepMeLoggedIn.value}',
      );

      debugPrint(
        'LoginController: Login successful, navigating to main screen',
      );
      Get.offAll(() => const MainNavigationScreen());
    } catch (e) {
      debugPrint('LoginController: Login failed - $e');

      String errorMessage = 'Login failed';

      if (e is DioException) {
        if (e.response != null) {
          final statusCode = e.response!.statusCode;
          final responseData = e.response!.data;

          debugPrint('Error Status Code: $statusCode');
          debugPrint('Error Response: $responseData');

          if (statusCode == 401) {
            errorMessage = 'Invalid email or password';
          } else if (statusCode == 400) {
            errorMessage = responseData.toString();
          } else if (statusCode == 500) {
            errorMessage = 'Server error. Please try again later';
          } else {
            errorMessage = 'Error: ${e.response!.statusMessage}';
          }
        } else if (e.type == DioExceptionType.connectionTimeout) {
          errorMessage = 'Connection timeout. Check your internet';
        } else if (e.type == DioExceptionType.receiveTimeout) {
          errorMessage = 'Server not responding';
        } else if (e.type == DioExceptionType.connectionError) {
          errorMessage = 'Cannot connect to server. Check network';
        } else {
          errorMessage = 'Network error: ${e.message}';
        }
      } else {
        errorMessage = e.toString();
      }

      ToastService.showError(errorMessage);
    } finally {
      isLoading.value = false;
    }
  }
}
