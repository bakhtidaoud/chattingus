import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class TokenStorageService extends GetxService {
  final _storage = const FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _fcmTokenKey = 'fcm_token';

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // FCM Token methods
  Future<void> saveFCMToken(String fcmToken) async {
    await _storage.write(key: _fcmTokenKey, value: fcmToken);
  }

  Future<String?> getFCMToken() async {
    return await _storage.read(key: _fcmTokenKey);
  }

  Future<void> clearFCMToken() async {
    await _storage.delete(key: _fcmTokenKey);
  }

  // User ID methods (for error logging)
  Future<String?> getUserId() async {
    // TODO: Store user ID during login and retrieve it here
    // For now, return null
    return null;
  }
}
