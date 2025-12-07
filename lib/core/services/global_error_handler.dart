import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'error_logging_service.dart';
import 'error_dialog_service.dart';

class GlobalErrorHandler {
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Catch async errors
    runZonedGuarded(
      () {
        // App will run in this zone
      },
      (error, stackTrace) {
        _handleZoneError(error, stackTrace);
      },
    );
  }

  static void _handleFlutterError(FlutterErrorDetails details) {
    // Log to console in debug mode
    FlutterError.presentError(details);

    // Log to error logging service
    try {
      final errorLoggingService = Get.find<ErrorLoggingService>();
      errorLoggingService.logCritical(
        details.exception.toString(),
        stackTrace: details.stack.toString(),
        screen: details.context?.toString() ?? 'Unknown',
        context: {
          'library': details.library ?? 'Unknown',
          'is_fatal': details.silent ? 'No' : 'Yes',
        },
      );
    } catch (e) {
      debugPrint('Failed to log Flutter error: $e');
    }

    // Show error dialog for critical errors
    if (!details.silent) {
      _showErrorDialog(
        'Application Error',
        'An unexpected error occurred. The app may not work correctly.',
      );
    }
  }

  static void _handleZoneError(Object error, StackTrace stackTrace) {
    debugPrint('🔥 Zone Error: $error');
    debugPrint('Stack trace:\n$stackTrace');

    // Log to error logging service
    try {
      final errorLoggingService = Get.find<ErrorLoggingService>();
      errorLoggingService.logCritical(
        error.toString(),
        stackTrace: stackTrace.toString(),
        screen: 'Zone Error',
      );
    } catch (e) {
      debugPrint('Failed to log zone error: $e');
    }

    // Show error dialog
    _showErrorDialog(
      'Unexpected Error',
      'Something went wrong. Please restart the app if issues persist.',
    );
  }

  static void _showErrorDialog(String title, String message) {
    try {
      final errorDialogService = Get.find<ErrorDialogService>();
      errorDialogService.showError(
        title: title,
        message: message,
        type: ErrorType.unknown,
        severity: ErrorSeverity.critical,
      );
    } catch (e) {
      // Fallback if services not initialized
      debugPrint('Failed to show error dialog: $e');

      // Show basic snackbar
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  /// Manually log an error
  static void logError(
    String message, {
    String? stackTrace,
    String screen = 'Unknown',
    Map<String, dynamic>? context,
  }) {
    try {
      final errorLoggingService = Get.find<ErrorLoggingService>();
      errorLoggingService.logError(
        message: message,
        stackTrace: stackTrace,
        screen: screen,
        context: context,
      );
    } catch (e) {
      debugPrint('Failed to log error: $e');
    }
  }
}
