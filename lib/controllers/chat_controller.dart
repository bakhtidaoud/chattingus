import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../core/services/chat_service.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  final RxList<Chat> chats = <Chat>[].obs;
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoadingChats = false.obs;
  final RxBool isLoadingMessages = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChats();
  }

  Future<void> fetchChats() async {
    try {
      isLoadingChats.value = true;
      final fetchedChats = await _chatService.fetchChats();
      chats.assignAll(fetchedChats);
    } catch (e) {
      debugPrint('Error fetching chats: $e');
      Get.snackbar('Error', 'Failed to load chats');
    } finally {
      isLoadingChats.value = false;
    }
  }

  Future<void> fetchMessages(int chatId) async {
    try {
      isLoadingMessages.value = true;
      final fetchedMessages = await _chatService.fetchMessages(chatId);
      messages.assignAll(fetchedMessages);
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      Get.snackbar('Error', 'Failed to load messages');
    } finally {
      isLoadingMessages.value = false;
    }
  }

  Future<void> sendMessage(int chatId, String content) async {
    if (content.trim().isEmpty) return;

    try {
      final newMessage = await _chatService.sendMessage(chatId, content);
      messages.add(newMessage);
      // Optionally update the chat list's last message locally
      final index = chats.indexWhere((c) => c.id == chatId);
      if (index != -1) {
        // This would require Chat to be mutable or creating a copy.
        // For now, we might just re-fetch chats or ignore updating the list view immediately.
        fetchChats();
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      Get.snackbar('Error', 'Failed to send message');
    }
  }
}
