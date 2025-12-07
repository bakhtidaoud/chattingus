import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../network/api_client.dart';
import 'token_storage_service.dart';

enum LogLevel { info, warning, error, critical }

class ErrorLog {
  final String message;
  final String? stackTrace;
  final LogLevel level;
  final String screen;
  final DateTime timestamp;
  final Map<String, dynamic>? context;

  ErrorLog({
    required this.message,
    this.stackTrace,
    required this.level,
    required this.screen,
    required this.timestamp,
    this.context,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'stack_trace': stackTrace,
    'level': level.name,
    'screen': screen,
    'timestamp': timestamp.toIso8601String(),
    'context': context,
  };
}

class ErrorLoggingService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final TokenStorageService _tokenService = Get.find<TokenStorageService>();

  final List<ErrorLog> _queuedLogs = [];
  final int _maxQueueSize = 50;
  String? _deviceInfo;

  @override
  void onInit() {
    super.onInit();
    _initDeviceInfo();
  }

  Future<void> _initDeviceInfo() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        _deviceInfo =
            '${androidInfo.brand} ${androidInfo.model} (Android ${androidInfo.version.release})';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        _deviceInfo =
            '${iosInfo.name} ${iosInfo.model} (iOS ${iosInfo.systemVersion})';
      }
    } catch (e) {
      debugPrint('Error getting device info: $e');
      _deviceInfo = 'Unknown Device';
    }
  }

  Future<void> logError({
    required String message,
    String? stackTrace,
    LogLevel level = LogLevel.error,
    String screen = 'Unknown',
    Map<String, dynamic>? context,
  }) async {
    final log = ErrorLog(
      message: message,
      stackTrace: stackTrace,
      level: level,
      screen: screen,
      timestamp: DateTime.now(),
      context: context,
    );

    // Log to console
    _logToConsole(log);

    // Add to queue
    _queuedLogs.add(log);
    if (_queuedLogs.length > _maxQueueSize) {
      _queuedLogs.removeAt(0);
    }

    // Try to send to backend
    await _sendToBackend(log);
  }

  void _logToConsole(ErrorLog log) {
    final emoji = _getEmojiForLevel(log.level);
    final timestamp = log.timestamp.toIso8601String();

    debugPrint('$emoji [$timestamp] [${log.screen}] ${log.message}');
    if (log.stackTrace != null) {
      debugPrint('Stack trace:\n${log.stackTrace}');
    }
    if (log.context != null) {
      debugPrint('Context: ${log.context}');
    }
  }

  String _getEmojiForLevel(LogLevel level) {
    switch (level) {
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.critical:
        return '🔥';
    }
  }

  Future<void> _sendToBackend(ErrorLog log) async {
    try {
      final token = await _tokenService.getAccessToken();
      if (token == null) {
        debugPrint('No token available, queuing error log');
        return;
      }

      final userId = await _tokenService.getUserId();

      final payload = {
        ...log.toJson(),
        'user_id': userId,
        'device_info': _deviceInfo,
        'app_version': '1.0.0', // TODO: Get from package_info
      };

      await _apiClient.dio.post('/errors/log/', data: payload);

      debugPrint('✅ Error log sent to backend');
    } catch (e) {
      debugPrint('Failed to send error log to backend: $e');
      // Keep in queue for retry
    }
  }

  Future<void> sendQueuedLogs() async {
    if (_queuedLogs.isEmpty) return;

    debugPrint('Sending ${_queuedLogs.length} queued error logs...');

    final logsToSend = List<ErrorLog>.from(_queuedLogs);
    _queuedLogs.clear();

    for (final log in logsToSend) {
      await _sendToBackend(log);
    }
  }

  // Convenience methods
  void logInfo(
    String message, {
    String screen = 'Unknown',
    Map<String, dynamic>? context,
  }) {
    logError(
      message: message,
      level: LogLevel.info,
      screen: screen,
      context: context,
    );
  }

  void logWarning(
    String message, {
    String screen = 'Unknown',
    Map<String, dynamic>? context,
  }) {
    logError(
      message: message,
      level: LogLevel.warning,
      screen: screen,
      context: context,
    );
  }

  void logCritical(
    String message, {
    String? stackTrace,
    String screen = 'Unknown',
    Map<String, dynamic>? context,
  }) {
    logError(
      message: message,
      stackTrace: stackTrace,
      level: LogLevel.critical,
      screen: screen,
      context: context,
    );
  }
}
