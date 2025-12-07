import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../network/api_client.dart';
import 'token_storage_service.dart';
import 'notification_service.dart';

class AuthService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final TokenStorageService _tokenService = Get.find<TokenStorageService>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final RxBool isLoggedIn = false.obs;

  Future<bool> checkAuthState() async {
    final token = await _tokenService.getAccessToken();
    if (token != null) {
      isLoggedIn.value = true;
      return true;
    }
    isLoggedIn.value = false;
    return false;
  }

  Future<void> login(String username, String password) async {
    try {
      debugPrint('=== LOGIN ATTEMPT ===');
      debugPrint('Username/Email: $username');
      debugPrint('Password length: ${password.length}');
      debugPrint('API Endpoint: /token/');

      final response = await _apiClient.post(
        '/token/',
        data: {'username': username, 'password': password},
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final accessToken = response.data['access'];
        final refreshToken = response.data['refresh'];

        debugPrint(
          'Access Token received: ${accessToken?.substring(0, 20)}...',
        );
        debugPrint(
          'Refresh Token received: ${refreshToken?.substring(0, 20)}...',
        );

        await _tokenService.saveTokens(accessToken, refreshToken);
        isLoggedIn.value = true;

        debugPrint('Login successful! Tokens saved.');

        // Register FCM token after successful login
        try {
          final notificationService = Get.find<NotificationService>();
          final fcmToken = await notificationService.getFCMToken();
          if (fcmToken != null) {
            await notificationService.registerFCMToken(fcmToken, accessToken);
            debugPrint('FCM token registered successfully');
          }
        } catch (e) {
          // Don't fail login if notification registration fails
          debugPrint('Failed to register FCM token: $e');
        }
      } else {
        debugPrint('Login failed with status: ${response.statusCode}');
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('=== LOGIN ERROR ===');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error message: $e');
      if (e is DioException) {
        debugPrint('DioException type: ${e.type}');
        debugPrint('Response data: ${e.response?.data}');
        debugPrint('Response status: ${e.response?.statusCode}');
        debugPrint('Response message: ${e.response?.statusMessage}');
      }
      rethrow;
    }
  }

  /// Register a new user
  /// POST /users/register/
  /// Required fields: username, email, password, password2, first_name, last_name, phone_number
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String password2,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        '/users/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password2': password2,
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registration successful
        // Optionally auto-login here if the backend returns tokens on register
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      rethrow;
    }
  }

  /// Refresh the access token using the refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null) {
        debugPrint('No refresh token available');
        return false;
      }

      debugPrint('=== REFRESHING TOKEN ===');

      final response = await _apiClient.post(
        '/token/refresh/',
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'];

        // Some backends also return a new refresh token
        final newRefreshToken = response.data['refresh'] ?? refreshToken;

        await _tokenService.saveTokens(newAccessToken, newRefreshToken);

        debugPrint('✅ Token refreshed successfully');
        return true;
      } else {
        debugPrint('Token refresh failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('=== TOKEN REFRESH ERROR ===');
      debugPrint('Error: $e');

      // If refresh fails, user needs to login again
      await logout();
      return false;
    }
  }

  /// Sign in with Google using Firebase
  /// Returns user data from backend
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      debugPrint('=== GOOGLE SIGN-IN ATTEMPT ===');

      // Step 1: Sign in with Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        debugPrint('Google sign-in cancelled by user');
        throw Exception('Google sign-in cancelled');
      }

      debugPrint('Google user: ${googleUser.email}');

      // Step 2: Get Google authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 3: Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4: Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      // Step 5: Get Firebase ID token
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      debugPrint('Firebase ID token obtained');

      // Step 6: Send to Django backend
      final response = await _apiClient.post(
        '/users/auth/firebase/',
        data: {'id_token': idToken, 'provider': 'google'},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Step 7: Save JWT tokens
        await _tokenService.saveTokens(data['access'], data['refresh']);
        isLoggedIn.value = true;

        debugPrint('✅ Google sign-in successful');
        debugPrint('User: ${data['email']}');
        debugPrint('Created: ${data['created']}');

        // Register FCM token
        try {
          final notificationService = Get.find<NotificationService>();
          final fcmToken = await notificationService.getFCMToken();
          if (fcmToken != null) {
            await notificationService.registerFCMToken(
              fcmToken,
              data['access'],
            );
          }
        } catch (e) {
          debugPrint('Failed to register FCM token: $e');
        }

        return data;
      } else {
        throw Exception(
          'Backend authentication failed: ${response.statusMessage}',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('=== FIREBASE AUTH ERROR ===');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');

      // Handle specific Firebase errors
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception(
            'An account already exists with the same email but different sign-in credentials',
          );
        case 'invalid-credential':
          throw Exception('Invalid credentials. Please try again');
        case 'operation-not-allowed':
          throw Exception('Google sign-in is not enabled');
        case 'user-disabled':
          throw Exception('This account has been disabled');
        case 'user-not-found':
          throw Exception('No account found with this email');
        case 'wrong-password':
          throw Exception('Wrong password');
        default:
          throw Exception('Google sign-in failed: ${e.message}');
      }
    } on DioException catch (e) {
      debugPrint('=== BACKEND ERROR ===');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Data: ${e.response?.data}');

      // Handle backend errors
      if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data['error'] ??
            e.response?.data['detail'] ??
            'Authentication failed';
        throw Exception(errorMessage);
      }

      rethrow;
    } catch (e) {
      debugPrint('=== GOOGLE SIGN-IN ERROR ===');
      debugPrint('Error: $e');
      rethrow;
    }
  }

  /// Sign in with Microsoft using Firebase
  /// Returns user data from backend
  Future<Map<String, dynamic>> signInWithMicrosoft() async {
    try {
      debugPrint('=== MICROSOFT SIGN-IN ATTEMPT ===');

      // Step 1: Create Microsoft OAuth provider
      final microsoftProvider = OAuthProvider('microsoft.com');

      // Optional: Add scopes
      microsoftProvider.addScope('email');
      microsoftProvider.addScope('profile');

      // Step 2: Sign in with Microsoft via Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithProvider(microsoftProvider);

      debugPrint('Microsoft user: ${userCredential.user?.email}');

      // Step 3: Get Firebase ID token
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      debugPrint('Firebase ID token obtained');

      // Step 4: Send to Django backend
      final response = await _apiClient.post(
        '/users/auth/firebase/',
        data: {'id_token': idToken, 'provider': 'microsoft'},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Step 5: Save JWT tokens
        await _tokenService.saveTokens(data['access'], data['refresh']);
        isLoggedIn.value = true;

        debugPrint('✅ Microsoft sign-in successful');
        debugPrint('User: ${data['email']}');
        debugPrint('Created: ${data['created']}');

        // Register FCM token
        try {
          final notificationService = Get.find<NotificationService>();
          final fcmToken = await notificationService.getFCMToken();
          if (fcmToken != null) {
            await notificationService.registerFCMToken(
              fcmToken,
              data['access'],
            );
          }
        } catch (e) {
          debugPrint('Failed to register FCM token: $e');
        }

        return data;
      } else {
        throw Exception(
          'Backend authentication failed: ${response.statusMessage}',
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('=== FIREBASE AUTH ERROR ===');
      debugPrint('Code: ${e.code}');
      debugPrint('Message: ${e.message}');

      // Handle specific Firebase errors
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw Exception(
            'An account already exists with the same email but different sign-in credentials',
          );
        case 'invalid-credential':
          throw Exception('Invalid credentials. Please try again');
        case 'operation-not-allowed':
          throw Exception('Microsoft sign-in is not enabled');
        case 'user-disabled':
          throw Exception('This account has been disabled');
        case 'user-cancelled':
          throw Exception('Microsoft sign-in cancelled');
        default:
          throw Exception('Microsoft sign-in failed: ${e.message}');
      }
    } on DioException catch (e) {
      debugPrint('=== BACKEND ERROR ===');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Data: ${e.response?.data}');

      // Handle backend errors
      if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data['error'] ??
            e.response?.data['detail'] ??
            'Authentication failed';
        throw Exception(errorMessage);
      }

      rethrow;
    } catch (e) {
      debugPrint('=== MICROSOFT SIGN-IN ERROR ===');
      debugPrint('Error: $e');
      rethrow;
    }
  }

  /// Link a social account to existing user account
  /// Requires user to be logged in
  Future<Map<String, dynamic>> linkSocialAccount(String provider) async {
    try {
      debugPrint('=== LINK SOCIAL ACCOUNT: $provider ===');

      // Check if user is logged in
      final accessToken = await _tokenService.getAccessToken();
      if (accessToken == null) {
        throw Exception('User must be logged in to link social account');
      }

      String? idToken;

      // Step 1: Sign in with provider to get Firebase ID token
      if (provider == 'google') {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          throw Exception('Google sign-in cancelled');
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);

        idToken = await userCredential.user?.getIdToken();
      } else if (provider == 'microsoft') {
        final microsoftProvider = OAuthProvider('microsoft.com');
        microsoftProvider.addScope('email');
        microsoftProvider.addScope('profile');

        final UserCredential userCredential = await _firebaseAuth
            .signInWithProvider(microsoftProvider);

        idToken = await userCredential.user?.getIdToken();
      } else {
        throw Exception('Unsupported provider: $provider');
      }

      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Step 2: Send to backend to link account
      final response = await _apiClient.post(
        '/users/auth/link-social/',
        data: {'id_token': idToken, 'provider': provider},
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Social account linked successfully');
        return response.data;
      } else {
        throw Exception(
          'Failed to link social account: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      debugPrint('=== LINK SOCIAL ACCOUNT ERROR ===');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Data: ${e.response?.data}');

      // Handle specific backend errors
      if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data['error'] ??
            e.response?.data['detail'] ??
            'Failed to link social account';

        // Check for specific error messages
        if (errorMessage.contains('already associated')) {
          throw Exception(
            'This email is already associated with a different social account',
          );
        }

        throw Exception(errorMessage);
      }

      rethrow;
    } catch (e) {
      debugPrint('=== LINK SOCIAL ACCOUNT ERROR ===');
      debugPrint('Error: $e');
      rethrow;
    }
  }

  /// Unlink social account from user
  /// Requires user to be logged in
  Future<void> unlinkSocialAccount() async {
    try {
      debugPrint('=== UNLINK SOCIAL ACCOUNT ===');

      // Check if user is logged in
      final accessToken = await _tokenService.getAccessToken();
      if (accessToken == null) {
        throw Exception('User must be logged in to unlink social account');
      }

      // Send to backend
      final response = await _apiClient.post('/users/auth/unlink-social/');

      if (response.statusCode == 200) {
        debugPrint('✅ Social account unlinked successfully');
      } else {
        throw Exception(
          'Failed to unlink social account: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      debugPrint('=== UNLINK SOCIAL ACCOUNT ERROR ===');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Data: ${e.response?.data}');

      // Handle specific backend errors
      if (e.response?.statusCode == 400) {
        final errorMessage =
            e.response?.data['error'] ??
            e.response?.data['detail'] ??
            'Failed to unlink social account';

        // Check for password requirement error
        if (errorMessage.contains('password')) {
          throw Exception(
            'Cannot unlink social account. Please set a password first',
          );
        }

        throw Exception(errorMessage);
      }

      rethrow;
    } catch (e) {
      debugPrint('=== UNLINK SOCIAL ACCOUNT ERROR ===');
      debugPrint('Error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    // Unregister FCM token before logout
    try {
      final notificationService = Get.find<NotificationService>();
      final fcmToken = await _tokenService.getFCMToken();
      final accessToken = await _tokenService.getAccessToken();

      if (fcmToken != null && accessToken != null) {
        await notificationService.unregisterFCMToken(fcmToken, accessToken);
      }
    } catch (e) {
      // Don't fail logout if notification unregistration fails
      debugPrint('Failed to unregister FCM token: $e');
    }

    // Sign out from Firebase
    try {
      await _firebaseAuth.signOut();
      debugPrint('✅ Signed out from Firebase');
    } catch (e) {
      debugPrint('Failed to sign out from Firebase: $e');
    }

    // Sign out from Google
    try {
      await _googleSignIn.signOut();
      debugPrint('✅ Signed out from Google');
    } catch (e) {
      debugPrint('Failed to sign out from Google: $e');
    }

    await _tokenService.clearTokens();
    isLoggedIn.value = false;
    // Navigate to login screen
    // Get.offAllNamed('/login');
    // Assuming '/login' is the route name. If not, the user can configure it later.
  }
}
