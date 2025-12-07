import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';
import '../../models/stream_model.dart';
import '../../models/live_comment_model.dart';
import '../../models/reaction_model.dart';

class LiveService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // GET live/streams/ - List active streams
  Future<List<StreamModel>> getStreams() async {
    try {
      debugPrint('=== FETCHING ACTIVE STREAMS ===');
      final response = await _apiClient.get('/live/streams/');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final streams = data.map((json) => StreamModel.fromJson(json)).toList();
        debugPrint('Fetched ${streams.length} active streams');
        return streams;
      } else {
        throw Exception('Failed to fetch streams: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error fetching streams: $e');
      rethrow;
    }
  }

  // POST live/streams/ - Create new stream
  Future<StreamModel> createStream({
    required String title,
    String? description,
  }) async {
    try {
      debugPrint('=== CREATING NEW STREAM ===');
      debugPrint('Title: $title');

      final response = await _apiClient.post(
        '/live/streams/',
        data: {
          'title': title,
          if (description != null) 'description': description,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final stream = StreamModel.fromJson(response.data);
        debugPrint('Stream created successfully: ${stream.id}');
        return stream;
      } else {
        throw Exception('Failed to create stream: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error creating stream: $e');
      rethrow;
    }
  }

  // POST live/streams/{id}/start/ - Start stream
  Future<StreamModel> startStream(int streamId) async {
    try {
      debugPrint('=== STARTING STREAM ===');
      debugPrint('Stream ID: $streamId');

      final response = await _apiClient.post('/live/streams/$streamId/start/');

      if (response.statusCode == 200) {
        final stream = StreamModel.fromJson(response.data);
        debugPrint('Stream started successfully');
        return stream;
      } else {
        throw Exception('Failed to start stream: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error starting stream: $e');
      rethrow;
    }
  }

  // POST live/streams/{id}/end/ - End stream
  Future<StreamModel> endStream(int streamId) async {
    try {
      debugPrint('=== ENDING STREAM ===');
      debugPrint('Stream ID: $streamId');

      final response = await _apiClient.post('/live/streams/$streamId/end/');

      if (response.statusCode == 200) {
        final stream = StreamModel.fromJson(response.data);
        debugPrint('Stream ended successfully');
        return stream;
      } else {
        throw Exception('Failed to end stream: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error ending stream: $e');
      rethrow;
    }
  }

  // POST live/streams/{id}/join/ - Join as viewer
  Future<void> joinStream(int streamId) async {
    try {
      debugPrint('=== JOINING STREAM ===');
      debugPrint('Stream ID: $streamId');

      final response = await _apiClient.post('/live/streams/$streamId/join/');

      if (response.statusCode == 200) {
        debugPrint('Joined stream successfully');
      } else {
        throw Exception('Failed to join stream: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error joining stream: $e');
      rethrow;
    }
  }

  // POST live/streams/{id}/leave/ - Leave stream
  Future<void> leaveStream(int streamId) async {
    try {
      debugPrint('=== LEAVING STREAM ===');
      debugPrint('Stream ID: $streamId');

      final response = await _apiClient.post('/live/streams/$streamId/leave/');

      if (response.statusCode == 200) {
        debugPrint('Left stream successfully');
      } else {
        throw Exception('Failed to leave stream: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error leaving stream: $e');
      rethrow;
    }
  }

  // GET live/streams/{id}/viewers/ - Get viewers
  Future<List<Map<String, dynamic>>> getViewers(int streamId) async {
    try {
      debugPrint('=== FETCHING VIEWERS ===');
      debugPrint('Stream ID: $streamId');

      final response = await _apiClient.get('/live/streams/$streamId/viewers/');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        debugPrint('Fetched ${data.length} viewers');
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch viewers: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error fetching viewers: $e');
      rethrow;
    }
  }

  // GET live/streams/{id}/comments/ - Get comments
  Future<List<LiveComment>> getComments(int streamId) async {
    try {
      debugPrint('=== FETCHING COMMENTS ===');
      debugPrint('Stream ID: $streamId');

      final response = await _apiClient.get(
        '/live/streams/$streamId/comments/',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final comments = data
            .map((json) => LiveComment.fromJson(json))
            .toList();
        debugPrint('Fetched ${comments.length} comments');
        return comments;
      } else {
        throw Exception('Failed to fetch comments: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error fetching comments: $e');
      rethrow;
    }
  }

  // POST live/streams/{id}/comments/ - Post comment
  Future<LiveComment> postComment(int streamId, String text) async {
    try {
      debugPrint('=== POSTING COMMENT ===');
      debugPrint('Stream ID: $streamId');
      debugPrint('Comment: $text');

      final response = await _apiClient.post(
        '/live/streams/$streamId/comments/',
        data: {'text': text},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final comment = LiveComment.fromJson(response.data);
        debugPrint('Comment posted successfully');
        return comment;
      } else {
        throw Exception('Failed to post comment: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
      rethrow;
    }
  }

  // POST live/streams/{id}/reactions/ - Send reaction
  Future<void> sendReaction(int streamId, String reactionType) async {
    try {
      debugPrint('=== SENDING REACTION ===');
      debugPrint('Stream ID: $streamId');
      debugPrint('Reaction Type: $reactionType');

      final response = await _apiClient.post(
        '/live/streams/$streamId/reactions/',
        data: {'type': reactionType},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint('Reaction sent successfully');
      } else {
        throw Exception('Failed to send reaction: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error sending reaction: $e');
      rethrow;
    }
  }
}
