import 'package:get/get.dart';
import '../network/api_client.dart';
import '../../models/user_model.dart';

class UserService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Get current user profile
  /// GET /users/me/
  Future<User> getCurrentUserProfile() async {
    final response = await _apiClient.get('/users/me/');
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  /// Update current user profile
  /// PATCH /users/me/
  /// Example data: {'first_name': 'Johnny', 'bio': 'Updated bio'}
  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _apiClient.patch('/users/me/', data: data);
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  /// Search for users
  /// GET /users/search/?q=query
  Future<List<User>> searchUsers(String query) async {
    final response = await _apiClient.get(
      '/users/search/',
      queryParameters: {'q': query},
    );
    if (response.statusCode == 200) {
      // Handle paginated response (Django REST Framework pagination)
      if (response.data is Map && response.data.containsKey('results')) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => User.fromJson(json)).toList();
      }
      // Handle direct list response
      else if (response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to search users');
    }
  }
}
