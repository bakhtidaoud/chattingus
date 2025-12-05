import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import 'token_storage_service.dart';

/// Top-level function for handling background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
  debugPrint('Message data: ${message.data}');
  debugPrint('Message notification: ${message.notification?.title}');
}

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiClient _apiClient = Get.find<ApiClient>();
  final TokenStorageService _tokenStorage = Get.find<TokenStorageService>();

  /// Get the FCM token from Firebase
  Future<String?> getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Request notification permissions (iOS and Android)
  Future<bool> requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint(
        'Notification permission status: ${settings.authorizationStatus}',
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Register FCM token with backend API
  Future<bool> registerFCMToken(String token, String jwtToken) async {
    try {
      // Check if token is already registered to avoid redundant API calls
      final prefs = await SharedPreferences.getInstance();
      final registeredToken = prefs.getString('registered_fcm_token');

      if (registeredToken == token) {
        debugPrint('FCM token already registered, skipping API call');
        return true;
      }

      final response = await _apiClient.post(
        '/notifications/preferences/add-fcm-token/',
        data: {'token': token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('FCM token registered successfully');
        await _tokenStorage.saveFCMToken(token);
        // Mark this token as registered
        await prefs.setString('registered_fcm_token', token);
        return true;
      } else {
        debugPrint('Failed to register FCM token: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
      return false;
    }
  }

  /// Unregister FCM token from backend API
  Future<bool> unregisterFCMToken(String token, String jwtToken) async {
    try {
      final response = await _apiClient.post(
        '/notifications/preferences/remove-fcm-token/',
        data: {'token': token},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('FCM token unregistered successfully');
        await _tokenStorage.clearFCMToken();

        // Clear registration tracking
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('registered_fcm_token');

        return true;
      } else {
        debugPrint('Failed to unregister FCM token: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      debugPrint('Error unregistering FCM token: $e');
      return false;
    }
  }

  /// Setup notification handlers for all app states
  Future<void> setupNotificationHandlers() async {
    // Request permissions first
    final permissionGranted = await requestPermission();
    if (!permissionGranted) {
      debugPrint('Notification permission not granted');
      return;
    }

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.messageId}');
      _handleForegroundNotification(message);
    });

    // Handle notification when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        'App opened from background notification: ${message.messageId}',
      );
      _handleNotificationNavigation(message);
    });

    // Check for initial notification if app was opened from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        'App opened from terminated state: ${initialMessage.messageId}',
      );
      _handleNotificationNavigation(initialMessage);
    }
  }

  /// Listen to FCM token refresh and update backend
  void listenToTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      debugPrint('FCM token refreshed: $newToken');

      // Get stored token to check if it changed
      final storedToken = await _tokenStorage.getFCMToken();
      if (storedToken != newToken) {
        // Get JWT token
        final jwtToken = await _tokenStorage.getAccessToken();
        if (jwtToken != null) {
          // Unregister old token if exists
          if (storedToken != null) {
            await unregisterFCMToken(storedToken, jwtToken);
          }
          // Register new token
          await registerFCMToken(newToken, jwtToken);
        }
      }
    });
  }

  /// Handle foreground notification display
  void _handleForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      // Display in-app notification
      Get.snackbar(
        notification.title ?? 'ChattingUs',
        notification.body ?? '',
        duration: const Duration(seconds: 4),
        onTap: (_) => _handleNotificationNavigation(message),
      );
    }

    debugPrint('Notification data: $data');
  }

  /// Navigate to appropriate screen based on notification type
  void _handleNotificationNavigation(RemoteMessage message) {
    final data = message.data;

    if (data.isEmpty) {
      debugPrint('No data in notification');
      return;
    }

    final notificationType = data['notification_type'] as String?;
    final senderId = data['sender_id'] as String?;
    final link = data['link'] as String?;

    debugPrint('Notification type: $notificationType');
    debugPrint('Sender ID: $senderId');
    debugPrint('Link: $link');

    // Navigate based on notification type
    switch (notificationType) {
      case 'message':
        // Navigate to chat screen
        if (senderId != null) {
          _navigateToChat(senderId);
        }
        break;

      case 'follow':
        // Navigate to user profile
        if (link != null) {
          _navigateToProfile(link);
        }
        break;

      case 'comment':
        // Navigate to post/story
        if (link != null) {
          _navigateToPost(link);
        }
        break;

      case 'like':
        // Navigate to post
        if (link != null) {
          _navigateToPost(link);
        }
        break;

      case 'mention':
        // Navigate to post/comment
        if (link != null) {
          _navigateToPost(link);
        }
        break;

      default:
        debugPrint('Unknown notification type: $notificationType');
    }
  }

  /// Navigate to chat screen
  void _navigateToChat(String senderId) {
    // TODO: Implement navigation to chat screen
    // Example: Get.toNamed('/chat', arguments: {'userId': senderId});
    debugPrint('Navigate to chat with user: $senderId');
  }

  /// Navigate to user profile
  void _navigateToProfile(String link) {
    // TODO: Implement navigation to profile screen
    // Example: Get.toNamed('/profile', arguments: {'username': username});
    debugPrint('Navigate to profile: $link');
  }

  /// Navigate to post
  void _navigateToPost(String link) {
    // TODO: Implement navigation to post screen
    // Example: Get.toNamed('/post', arguments: {'postId': postId});
    debugPrint('Navigate to post: $link');
  }

  /// Initialize notification service
  Future<void> initialize() async {
    await setupNotificationHandlers();
    listenToTokenRefresh();
  }
}
