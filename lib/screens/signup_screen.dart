import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../l10n/app_localizations.dart';
import '../controllers/signup_controller.dart';
import '../core/services/auth_service.dart';
import 'main_navigation_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController controller = Get.put(SignUpController());
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  l10n.createAccount,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: l10n.signUpGoogle,
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: controller.isLoading.value
                      ? null
                      : () => _handleGoogleSignUp(context),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => _SocialButton(
                  icon: Icons.window,
                  label: l10n.signUpMicrosoft,
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: controller.isLoading.value
                      ? null
                      : () => _handleMicrosoftSignUp(context),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.or,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 32),
              _CustomTextField(
                hintText: l10n.firstName,
                controller: controller.firstNameController,
              ),
              const SizedBox(height: 16),
              _CustomTextField(
                hintText: l10n.lastName,
                controller: controller.lastNameController,
              ),
              const SizedBox(height: 16),
              _CustomTextField(
                hintText: l10n.emailAddress,
                controller: controller.emailController,
              ),
              const SizedBox(height: 16),
              _CustomTextField(
                hintText: l10n.phoneNumber,
                controller: controller.phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              Obx(
                () => _CustomTextField(
                  hintText: l10n.password,
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => _CustomTextField(
                  hintText: l10n.confirmPassword,
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.isAgreed.value,
                      onChanged: (value) => controller.toggleAgreement(),
                      fillColor: MaterialStateProperty.all(
                        Colors.grey.shade800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(l10n.agreeTo + ' '),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            l10n.termsOfService,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        Text(' ' + l10n.and + ' '),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            l10n.privacyPolicy,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        const Text('.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            l10n.signUp,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.alreadyHaveAccount + ' ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      l10n.logIn,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignUp(BuildContext context) async {
    final authService = Get.find<AuthService>();
    final controller = Get.find<SignUpController>();

    try {
      controller.isLoading.value = true;
      final userData = await authService.signInWithGoogle();
      controller.isLoading.value = false;

      Get.offAll(() => const MainNavigationScreen());
      Get.snackbar(
        'Success',
        'Welcome ${userData['email']}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      controller.isLoading.value = false;
      if (e.toString().contains('cancelled')) return;

      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _handleMicrosoftSignUp(BuildContext context) async {
    final authService = Get.find<AuthService>();
    final controller = Get.find<SignUpController>();

    try {
      controller.isLoading.value = true;
      final userData = await authService.signInWithMicrosoft();
      controller.isLoading.value = false;

      Get.offAll(() => const MainNavigationScreen());
      Get.snackbar(
        'Success',
        'Welcome ${userData['email']}!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      controller.isLoading.value = false;
      if (e.toString().contains('cancelled')) return;

      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    }
  }
}

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const _CustomTextField({
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: theme.brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
