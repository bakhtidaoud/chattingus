import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/premium_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      // Final submission logic
      context.go('/otp');
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background accents...
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.electricViolet.withOpacity(0.1),
              ),
            ).animate().fadeIn().scale(),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Progress Indicator
                _buildProgressIndicator(),
                const SizedBox(height: 40),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildAccountStep(),
                      _buildProfileStep(),
                      _buildReferralStep(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive ? AppTheme.primaryIndigo : Colors.white10,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryIndigo.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
            ).animate(target: isActive ? 1 : 0).shimmer(duration: 1.seconds),
          );
        }),
      ),
    );
  }

  Widget _buildAccountStep() {
    return _buildStepWrapper(
      title: 'Create Account',
      subtitle: 'Enter your basic credentials to begin',
      children: [
        const GlassTextField(
          hintText: 'Username',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        const GlassTextField(
          hintText: 'Email Address',
          prefixIcon: Icons.email_outlined,
        ),
        const SizedBox(height: 16),
        const GlassTextField(
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
      ],
    );
  }

  Widget _buildProfileStep() {
    return _buildStepWrapper(
      title: 'Complete Profile',
      subtitle: 'Tell us a bit more about yourself',
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white10,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  size: 32,
                  color: Colors.white54,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryIndigo,
                  ),
                  child: const Icon(Icons.add, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const GlassTextField(
          hintText: 'Full Name',
          prefixIcon: Icons.badge_outlined,
        ),
        const SizedBox(height: 16),
        const GlassTextField(
          hintText: 'Bio (Optional)',
          prefixIcon: Icons.info_outline,
        ),
      ],
    );
  }

  Widget _buildReferralStep() {
    return _buildStepWrapper(
      title: 'Referral Code',
      subtitle: 'Have a code from a friend?',
      children: [
        const GlassTextField(hintText: 'Code', prefixIcon: Icons.card_giftcard),
        const SizedBox(height: 16),
        Text(
          'Skip this step if you don\'t have a code.',
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepWrapper({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
          const SizedBox(height: 48),
          ...children,
          const Spacer(),
          Row(
            children: [
              if (_currentStep > 0) ...[
                Expanded(
                  child: TextButton(
                    onPressed: _prevStep,
                    child: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                flex: 2,
                child: PremiumButton(
                  text: _currentStep == 2 ? 'Complete' : 'Continue',
                  onPressed: _nextStep,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
