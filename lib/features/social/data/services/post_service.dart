import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class PostService {
  final Dio _dio = DioClient().dio;

  Future<Response> getFeed({int page = 1}) async {
    return await _dio.get('/posts/feed/', queryParameters: {'page': page});
  }

  Future<Response> createPost({
    required String caption,
    File? media,
    String? location,
  }) async {
    FormData formData = FormData.fromMap({
      'caption': caption,
      if (location != null) 'location': location,
      if (media != null)
        'media': await MultipartFile.fromFile(
          media.path,
          filename: media.path.split('/').last,
        ),
    });

    return await _dio.post('/posts/', data: formData);
  }

  Future<Response> reactToPost(String postId, String reactionType) async {
    return await _dio.post(
      '/posts/$postId/react/',
      data: {'type': reactionType},
    );
  }

  Future<Response> getComments(String postId) async {
    return await _dio.get('/comments/', queryParameters: {'post_id': postId});
  }

  Future<Response> postComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    return await _dio.post(
      '/comments/',
      data: {
        'post_id': postId,
        'content': content,
        if (parentId != null) 'parent_id': parentId,
      },
    );
  }

  Future<Response> getTrendingHashtags() async {
    return await _dio.get('/hashtags/trending/');
  }

  Future<Response> savePost(String postId) async {
    return await _dio.post('/posts/$postId/save/');
  }
}
