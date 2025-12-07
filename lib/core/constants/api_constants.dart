import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  static String get baseUrl {
    if (kReleaseMode) {
      // Replace with your production URL
      return 'https://192.168.11.100:8000/api/';
    }

    if (Platform.isAndroid) {
      // 10.0.2.2 is the special alias to your host loopback interface (127.0.0.1)
      // on the Android emulator.
      return 'http://192.168.11.100:8000/api/';
    } else if (Platform.isIOS) {
      // iOS simulator uses localhost
      return 'http://127.0.0.1:8000/api/';
    } else {
      // Fallback for other platforms (web, desktop, etc.)
      return 'http://127.0.0.1:8000/api/';
    }
  }
}
