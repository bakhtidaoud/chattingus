import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ErrorType {
  network,
  permission,
  authentication,
  server,
  validation,
  unknown,
}

enum ErrorSeverity { info, warning, error, critical }

class ErrorDialogService extends GetxService {
  final Set<String> _shownErrors = {};

  void showError({
    required String title,
    required String message,
    ErrorType type = ErrorType.unknown,
    ErrorSeverity severity = ErrorSeverity.error,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
    bool showAsSnackbar = false,
  }) {
    final errorKey = '$title:$message';

    // Prevent duplicate errors
    if (_shownErrors.contains(errorKey)) {
      return;
    }

    _shownErrors.add(errorKey);

    if (showAsSnackbar) {
      _showSnackbar(title, message, type, severity, onRetry);
    } else {
      _showDialog(title, message, type, severity, onRetry, onDismiss);
    }

    // Clear error key after 3 seconds to allow showing again
    Future.delayed(const Duration(seconds: 3), () {
      _shownErrors.remove(errorKey);
    });
  }

  void _showSnackbar(
    String title,
    String message,
    ErrorType type,
    ErrorSeverity severity,
    VoidCallback? onRetry,
  ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _getColorForSeverity(severity),
      colorText: Colors.white,
      icon: Icon(_getIconForType(type), color: Colors.white),
      duration: const Duration(seconds: 4),
      mainButton: onRetry != null
          ? TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                onRetry();
              },
              child: const Text('RETRY', style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  void _showDialog(
    String title,
    String message,
    ErrorType type,
    ErrorSeverity severity,
    VoidCallback? onRetry,
    VoidCallback? onDismiss,
  ) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(_getIconForType(type), color: _getColorForSeverity(severity)),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          if (type == ErrorType.permission)
            TextButton(
              onPressed: () {
                Get.back();
                // Open app settings
                // openAppSettings(); // Requires permission_handler
              },
              child: const Text('Open Settings'),
            ),
          if (type == ErrorType.authentication)
            TextButton(
              onPressed: () {
                Get.back();
                // Navigate to login
                // Get.offAll(() => const LoginScreen());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Get.back();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () {
              Get.back();
              onDismiss?.call();
            },
            child: const Text('Dismiss'),
          ),
        ],
      ),
      barrierDismissible: severity != ErrorSeverity.critical,
    );
  }

  IconData _getIconForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.permission:
        return Icons.lock;
      case ErrorType.authentication:
        return Icons.person_off;
      case ErrorType.server:
        return Icons.cloud_off;
      case ErrorType.validation:
        return Icons.error_outline;
      case ErrorType.unknown:
        return Icons.warning;
    }
  }

  Color _getColorForSeverity(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.info:
        return Colors.blue;
      case ErrorSeverity.warning:
        return Colors.orange;
      case ErrorSeverity.error:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.red.shade900;
    }
  }

  void showNetworkError({VoidCallback? onRetry}) {
    showError(
      title: 'Network Error',
      message: 'Please check your internet connection and try again.',
      type: ErrorType.network,
      severity: ErrorSeverity.error,
      onRetry: onRetry,
      showAsSnackbar: true,
    );
  }

  void showPermissionError(String permission) {
    showError(
      title: 'Permission Required',
      message:
          '$permission permission is required. Please enable it in Settings.',
      type: ErrorType.permission,
      severity: ErrorSeverity.warning,
    );
  }

  void showAuthError() {
    showError(
      title: 'Session Expired',
      message: 'Your session has expired. Please log in again.',
      type: ErrorType.authentication,
      severity: ErrorSeverity.error,
    );
  }

  void showServerError({VoidCallback? onRetry}) {
    showError(
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      type: ErrorType.server,
      severity: ErrorSeverity.error,
      onRetry: onRetry,
      showAsSnackbar: true,
    );
  }
}
