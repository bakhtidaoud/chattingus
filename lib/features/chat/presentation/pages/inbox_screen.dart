import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../providers/chat_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: conversationsAsync.when(
        data: (conversations) {
          final currentUserId = userAsync.value?.id ?? "0";
          return RefreshIndicator(
            onRefresh: () => ref.refresh(conversationsProvider.future),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _ConversationTile(
                  conversation: conversation,
                  currentUserId: currentUserId,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final dynamic conversation;
  final String currentUserId;

  const _ConversationTile({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          onTap: () => context.push('/chat/${conversation.id}'),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: CachedNetworkImageProvider(
                  conversation.getDisplayAvatar(currentUserId),
                ),
              ),
              if (!conversation.isGroup)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.midnight, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            conversation.getDisplayTitle(currentUserId),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            conversation.lastMessage ?? 'No messages yet',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: conversation.unreadCount > 0
                  ? Colors.white
                  : Colors.white60,
              fontWeight: conversation.unreadCount > 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Just now',
                style: TextStyle(fontSize: 12, color: Colors.white24),
              ),
              if (conversation.unreadCount > 0) ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryIndigo,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    conversation.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ).animate().fadeIn().slideX(begin: 0.1, end: 0),
    );
  }
}
