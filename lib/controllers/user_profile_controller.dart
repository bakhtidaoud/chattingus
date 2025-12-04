import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../core/services/user_service.dart';
import '../models/user_model.dart';

class UserProfileController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Load current user profile
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final user = await _userService.getCurrentUserProfile();
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = 'Failed to load profile: $e';
      debugPrint('Error loading user profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final updatedUser = await _userService.updateProfile(data);
      currentUser.value = updatedUser;
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to update profile: $e';
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Search for users
  Future<List<User>> searchUsers(String query) async {
    try {
      errorMessage.value = '';
      return await _userService.searchUsers(query);
    } catch (e) {
      errorMessage.value = 'Failed to search users: $e';
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  /// Get user display name
  String get displayName {
    if (currentUser.value == null) return '';
    final user = currentUser.value!;
    if (user.firstName != null && user.lastName != null) {
      return '${user.firstName} ${user.lastName}';
    }
    return user.username;
  }
}
