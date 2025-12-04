import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/auth_service.dart';
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
      Get.snackbar(
        'Error',
        'Please agree to the Terms of Service and Privacy Policy',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
      );
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

      Get.snackbar(
        'Success',
        'Account created successfully! Please login.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login screen
      Get.off(() => const LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
