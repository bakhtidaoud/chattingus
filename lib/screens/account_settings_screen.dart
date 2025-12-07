import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/auth_service.dart';
import 'change_password_screen.dart';

class AccountSettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isGoogleLinked = false.obs;
  final RxBool isMicrosoftLinked = false.obs;
  final RxString googleEmail = ''.obs;
  final RxString microsoftEmail = ''.obs;
  final RxBool hasPassword = true.obs; // TODO: Get from user profile
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAccountStatus();
  }

  Future<void> _loadAccountStatus() async {
    // TODO: Fetch user profile to check linked accounts
    // For now, using mock data
    isLoading.value = true;
    try {
      // Replace with actual API call to get user profile
      // final profile = await _userService.getProfile();
      // isGoogleLinked.value = profile.authProvider == 'google';
      // googleEmail.value = profile.googleEmail ?? '';
      // hasPassword.value = profile.hasPassword;
    } catch (e) {
      debugPrint('Error loading account status: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> linkGoogleAccount() async {
    try {
      isLoading.value = true;
      final userData = await _authService.linkSocialAccount('google');

      isGoogleLinked.value = true;
      googleEmail.value = userData['email'] ?? '';

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Google account linked successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.back(); // Close loading dialog

      String errorMessage = e.toString().replaceAll('Exception: ', '');

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> linkMicrosoftAccount() async {
    try {
      isLoading.value = true;
      final userData = await _authService.linkSocialAccount('microsoft');

      isMicrosoftLinked.value = true;
      microsoftEmail.value = userData['email'] ?? '';

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Microsoft account linked successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.back(); // Close loading dialog

      String errorMessage = e.toString().replaceAll('Exception: ', '');

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unlinkSocialAccount() async {
    try {
      isLoading.value = true;
      await _authService.unlinkSocialAccount();

      isGoogleLinked.value = false;
      isMicrosoftLinked.value = false;
      googleEmail.value = '';
      microsoftEmail.value = '';

      Get.back(); // Close loading dialog
      Get.snackbar(
        'Success',
        'Social account unlinked successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.back(); // Close loading dialog

      String errorMessage = e.toString().replaceAll('Exception: ', '');

      // Check if error is about password requirement
      if (errorMessage.contains('password')) {
        _showPasswordRequiredDialog();
      } else {
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _showPasswordRequiredDialog() {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text('Password Required'),
          ],
        ),
        content: const Text(
          'You need to set a password before unlinking your social account. '
          'This ensures you can still access your account.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.to(() => const ChangePasswordScreen());
            },
            child: const Text('Set Password'),
          ),
        ],
      ),
    );
  }
}

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AccountSettingsController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings'), elevation: 0),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Connected Accounts Section
            Text(
              'Connected Accounts',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Link your social accounts for easier sign-in',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Google Account
            _buildAccountTile(
              context: context,
              controller: controller,
              provider: 'google',
              icon: Icons.g_mobiledata,
              iconColor: Colors.red,
              title: 'Google Account',
              isLinked: controller.isGoogleLinked.value,
              email: controller.googleEmail.value,
              onLink: () => _showLinkConfirmationDialog(
                context,
                'Google',
                controller.linkGoogleAccount,
              ),
              onUnlink: () => _showUnlinkWarningDialog(
                context,
                'Google',
                controller.unlinkSocialAccount,
                controller.hasPassword.value,
              ),
            ),

            const SizedBox(height: 16),

            // Microsoft Account
            _buildAccountTile(
              context: context,
              controller: controller,
              provider: 'microsoft',
              icon: Icons.window,
              iconColor: Colors.blue,
              title: 'Microsoft Account',
              isLinked: controller.isMicrosoftLinked.value,
              email: controller.microsoftEmail.value,
              onLink: () => _showLinkConfirmationDialog(
                context,
                'Microsoft',
                controller.linkMicrosoftAccount,
              ),
              onUnlink: () => _showUnlinkWarningDialog(
                context,
                'Microsoft',
                controller.unlinkSocialAccount,
                controller.hasPassword.value,
              ),
            ),

            const SizedBox(height: 32),

            // Security Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Linking accounts allows you to sign in with multiple methods',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAccountTile({
    required BuildContext context,
    required AccountSettingsController controller,
    required String provider,
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isLinked,
    required String email,
    required VoidCallback onLink,
    required VoidCallback onUnlink,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          isLinked ? email : 'Not connected',
          style: TextStyle(
            color: isLinked ? Colors.green.shade700 : Colors.grey,
            fontSize: 13,
          ),
        ),
        trailing: isLinked
            ? OutlinedButton(
                onPressed: onUnlink,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Unlink'),
              )
            : ElevatedButton(
                onPressed: onLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Link'),
              ),
      ),
    );
  }

  void _showLinkConfirmationDialog(
    BuildContext context,
    String provider,
    Future<void> Function() onConfirm,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('Link $provider Account?'),
        content: Text(
          'This will allow you to sign in using your $provider account.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close confirmation dialog

              // Show loading dialog
              Get.dialog(
                const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Linking account...'),
                        ],
                      ),
                    ),
                  ),
                ),
                barrierDismissible: false,
              );

              await onConfirm();
            },
            child: const Text('Link Account'),
          ),
        ],
      ),
    );
  }

  void _showUnlinkWarningDialog(
    BuildContext context,
    String provider,
    Future<void> Function() onConfirm,
    bool hasPassword,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 12),
            Text('Unlink Account?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to unlink your $provider account?'),
            const SizedBox(height: 12),
            if (!hasPassword)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You need a password to sign in after unlinking',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close warning dialog

              // Show loading dialog
              Get.dialog(
                const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Unlinking account...'),
                        ],
                      ),
                    ),
                  ),
                ),
                barrierDismissible: false,
              );

              await onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );
  }
}
