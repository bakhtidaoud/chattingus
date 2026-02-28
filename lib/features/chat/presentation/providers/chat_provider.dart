import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/models/chat_models.dart';
import '../../data/services/chat_service.dart';
import '../../data/services/chat_socket_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final chatServiceProvider = Provider((ref) => ChatService());
final chatSocketProvider = Provider((ref) => ChatSocketService());

final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final service = ref.watch(chatServiceProvider);
  final response = await service.getConversations();
  return (response.data as List).map((c) => Conversation.fromJson(c)).toList();
});

class ChatNotifier extends FamilyAsyncNotifier<List<Message>, String> {
  late final ChatService service;
  late final ChatSocketService socketService;
  late final String conversationId;
  late final String currentUserId;

  @override
  FutureOr<List<Message>> build(String arg) async {
    conversationId = arg;
    service = ref.read(chatServiceProvider);
    socketService = ref.read(chatSocketProvider);
    final user = ref.read(currentUserProvider).value;
    currentUserId = user?.id ?? "0";

    return _fetchMessages();
  }

  Future<List<Message>> _fetchMessages() async {
    final response = await service.getMessages(conversationId);
    final List<Message> messages = (response.data['results'] as List)
        .map((m) => Message.fromJson(m, currentUserId))
        .toList();

    // In a real app, you'd get the actual websocket token
    socketService.connect(conversationId, "WS_TOKEN").listen((msg) {
      // Handle incoming socket messages
    });

    return messages;
  }

  Future<void> send(String content) async {
    await service.sendMessage(conversationId: conversationId, content: content);
  }
}

final currentChatProvider =
    AsyncNotifierProvider.family<ChatNotifier, List<Message>, String>(() {
      return ChatNotifier();
    });
