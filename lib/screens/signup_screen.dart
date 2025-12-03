import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../l10n/app_localizations.dart';
import '../controllers/signup_controller.dart';

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
              _SocialButton(
                icon: Icons.facebook, // Placeholder for Facebook/Google
                label: l10n.signUpGoogle,
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              _SocialButton(
                icon: Icons.g_mobiledata, // Placeholder for GitHub/Microsoft
                label: l10n.signUpMicrosoft,
                color: Colors.white,
                textColor: Colors.black,
                onPressed: () {},
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
              _CustomTextField(hintText: l10n.firstName),
              const SizedBox(height: 16),
              _CustomTextField(hintText: l10n.lastName),
              const SizedBox(height: 16),
              _CustomTextField(hintText: l10n.emailAddress),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: theme.inputDecorationTheme.fillColor ?? Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: '+1',
                          items: ['+1', '+212', '+33'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: l10n.phoneNumber,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => _CustomTextField(
                hintText: l10n.password, // Corrected key
                obscureText: !controller.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              )),
              const SizedBox(height: 16),
              Obx(() => _CustomTextField(
                hintText: l10n.confirmPassword,
                obscureText: !controller.isConfirmPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
                ),
              )),
              const SizedBox(height: 24),
              Row(
                children: [
                  Obx(() => Checkbox(
                    value: controller.isAgreed.value,
                    onChanged: (value) => controller.toggleAgreement(),
                    fillColor: MaterialStateProperty.all(Colors.grey.shade800),
                  )),
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
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    l10n.signUp,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
}

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;

  const _CustomTextField({
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: theme.brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade200,
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
  final VoidCallback onPressed;

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
