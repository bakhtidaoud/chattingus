import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Service for displaying toast messages consistently across the app
class ToastService {
  /// Show success toast (green)
  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show error toast (red)
  static void showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show info toast (blue)
  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF2196F3),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show warning toast (orange)
  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFFF9800),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Show custom toast with custom colors
  static void showCustom({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Toast? length,
    ToastGravity? gravity,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: backgroundColor ?? Colors.grey[800],
      textColor: textColor ?? Colors.white,
      fontSize: 16.0,
    );
  }

  /// Cancel any currently showing toast
  static void cancel() {
    Fluttertoast.cancel();
  }
}
