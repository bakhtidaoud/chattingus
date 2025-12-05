import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/auth_service.dart';
import '../core/services/toast_service.dart';
import '../screens/login_screen.dart';

class SignUpController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable states
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isAgreed = false.obs;
  var isLoading = false.obs;
  var countryCode = '+1'.obs;

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }

  void updateCountryCode(String code) {
    countryCode.value = code;
  }

  Future<void> signup() async {
    // Validation
    if (!isAgreed.value) {
      ToastService.showError(
        'Please agree to the Terms of Service and Privacy Policy',
      );
      return;
    }

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ToastService.showError('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ToastService.showError('Passwords do not match');
      return;
    }

    if (passwordController.text.length < 6) {
      ToastService.showError('Password must be at least 6 characters');
      return;
    }

    // Generate username from email
    final username = emailController.text.split('@')[0];

    try {
      isLoading.value = true;

      await _authService.register(
        username: username,
        email: emailController.text.trim(),
        password: passwordController.text,
        password2: confirmPasswordController.text,
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: '${countryCode.value}${phoneNumberController.text.trim()}',
      );

      ToastService.showSuccess('Account created successfully! Please login.');

      // Navigate to login screen
      Get.off(() => const LoginScreen());
    } catch (e) {
      ToastService.showError('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
