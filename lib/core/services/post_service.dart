import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, MultipartFile, FormData;
import '../network/api_client.dart';
import '../../models/post_model.dart';
import '../../models/comment_model.dart';

class PostService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  /// Get feed (list of posts)
  /// GET /posts/
  Future<List<Post>> getFeed() async {
    final response = await _apiClient.get('/posts/');
    if (response.statusCode == 200) {
      // Handle paginated response (Django REST Framework pagination)
      if (response.data is Map && response.data.containsKey('results')) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => Post.fromJson(json)).toList();
      }
      // Handle direct list response
      else if (response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load feed');
    }
  }

  /// Create a new post
  /// POST /posts/
  /// Content-Type: multipart/form-data
  Future<Post> createPost({
    required String caption,
    required File image,
    String? location,
  }) async {
    // Create multipart form data
    final formData = FormData.fromMap({
      'caption': caption,
      'image': await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
      if (location != null) 'location': location,
    });

    final response = await _apiClient.dio.post(
      '/posts/',
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Post.fromJson(response.data);
    } else {
      throw Exception('Failed to create post');
    }
  }

  /// Like a post
  /// POST /posts/{id}/like/
  Future<void> likePost(int postId) async {
    final response = await _apiClient.post('/posts/$postId/like/');
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to like post');
    }
  }

  /// Add comment to a post
  /// POST /posts/{id}/comments/
  Future<Comment> addComment(int postId, String text) async {
    final response = await _apiClient.post(
      '/posts/$postId/comments/',
      data: {'text': text},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Comment.fromJson(response.data);
    } else {
      throw Exception('Failed to add comment');
    }
  }
}
