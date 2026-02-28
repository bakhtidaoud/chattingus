import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class ChatService {
  final Dio _dio = DioClient().dio;

  Future<Response> getConversations() async {
    return await _dio.get('/conversations/');
  }

  Future<Response> getMessages(String conversationId, {int page = 1}) async {
    return await _dio.get(
      '/conversations/$conversationId/messages/',
      queryParameters: {'page': page},
    );
  }

  Future<Response> sendMessage({
    required String conversationId,
    required String content,
    File? attachment,
  }) async {
    if (attachment != null) {
      FormData formData = FormData.fromMap({
        'content': content,
        'conversation_id': conversationId,
        'attachment': await MultipartFile.fromFile(
          attachment.path,
          filename: attachment.path.split('/').last,
        ),
      });
      return await _dio.post('/messages/', data: formData);
    }
    return await _dio.post(
      '/messages/',
      data: {'content': content, 'conversation_id': conversationId},
    );
  }

  Future<Response> deleteMessage(String messageId) async {
    return await _dio.post('/messages/$messageId/delete_for_me/');
  }

  Future<Response> addParticipants(
    String conversationId,
    List<String> userIds,
  ) async {
    return await _dio.post(
      '/conversations/$conversationId/add_participants/',
      data: {'user_ids': userIds},
    );
  }

  Future<Response> markAllAsRead(String conversationId) async {
    return await _dio.post('/conversations/$conversationId/mark_all_as_read/');
  }
}
