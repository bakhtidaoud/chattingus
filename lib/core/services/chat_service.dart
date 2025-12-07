import 'package:get/get.dart';
import '../network/api_client.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';

class ChatService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<Chat>> fetchChats() async {
    final response = await _apiClient.get('/chat/chats/');
    if (response.statusCode == 200) {
      // Handle paginated response
      if (response.data is Map && response.data.containsKey('results')) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => Chat.fromJson(json)).toList();
      }
      // Handle direct list response
      else if (response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => Chat.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<List<Message>> fetchMessages(int chatId) async {
    final response = await _apiClient.get(
      '/chat/messages/',
      queryParameters: {'chat_id': chatId},
    );
    if (response.statusCode == 200) {
      // Handle paginated response
      if (response.data is Map && response.data.containsKey('results')) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => Message.fromJson(json)).toList();
      }
      // Handle direct list response
      else if (response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Message> sendMessage(int chatId, String content) async {
    final response = await _apiClient.post(
      '/chat/messages/',
      data: {'chat': chatId, 'content': content},
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Message.fromJson(response.data);
    } else {
      throw Exception('Failed to send message');
    }
  }
}
