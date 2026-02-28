import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/premium_button.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              'Enter your email address to receive recovery instructions.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 64),

            const GlassTextField(
              hintText: 'Email Address',
              prefixIcon: Icons.email_outlined,
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

            const Spacer(),

            PremiumButton(
              text: 'Send Instructions',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Recovery instructions sent to your email.'),
                  ),
                );
                context.pop();
              },
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
