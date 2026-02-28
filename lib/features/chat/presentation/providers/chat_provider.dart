import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/chat_models.dart';
import '../../data/services/chat_service.dart';
import '../../data/services/chat_socket_service.dart';

final chatServiceProvider = Provider((ref) => ChatService());
final chatSocketProvider = Provider((ref) => ChatSocketService());

final conversationsProvider = FutureProvider<List<Conversation>>((ref) async {
  final service = ref.watch(chatServiceProvider);
  final response = await service.getConversations();
  return (response.data as List).map((c) => Conversation.fromJson(c)).toList();
});

class ChatNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  final ChatService service;
  final ChatSocketService socketService;
  final String conversationId;

  ChatNotifier({
    required this.service,
    required this.socketService,
    required this.conversationId,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final response = await service.getMessages(conversationId);
      final List<Message> messages = (response.data['results'] as List)
          .map((m) => Message.fromJson(m, "CURRENT_USER_ID"))
          .toList();
      state = AsyncValue.data(messages);

      socketService.connect(conversationId, "TOKEN").listen((msg) {
        // Update logic
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> send(String content) async {
    await service.sendMessage(conversationId: conversationId, content: content);
  }
}

final currentChatProvider =
    StateNotifierProvider.family<
      ChatNotifier,
      AsyncValue<List<Message>>,
      String
    >((ref, id) {
      return ChatNotifier(
        service: ref.watch(chatServiceProvider),
        socketService: ref.watch(chatSocketProvider),
        conversationId: id,
      );
    });
