import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class StoryService {
  final Dio _dio = DioClient().dio;

  Future<Response> getFollowingStories() async {
    return await _dio.get('/stories/following_stories/');
  }

  Future<Response> uploadStory({
    required File media,
    bool isVideo = false,
  }) async {
    FormData formData = FormData.fromMap({
      'media': await MultipartFile.fromFile(
        media.path,
        filename: media.path.split('/').last,
      ),
      'is_video': isVideo,
    });

    return await _dio.post('/stories/', data: formData);
  }

  Future<Response> recordView(String storyId) async {
    return await _dio.post('/stories/$storyId/record_view/');
  }

  Future<Response> reactToStory(String storyId, String emoji) async {
    return await _dio.post('/stories/$storyId/react/', data: {'emoji': emoji});
  }

  Future<Response> getHighlights(String userId) async {
    return await _dio.get('/highlights/', queryParameters: {'user_id': userId});
  }

  Future<Response> addStoryToHighlight(
    String highlightId,
    String storyId,
  ) async {
    return await _dio.post(
      '/highlights/$highlightId/add_story/',
      data: {'story_id': storyId},
    );
  }
}
