import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../stories/presentation/widgets/story_tray.dart';
import '../../../chat/presentation/providers/chat_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(conversationsProvider);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChattingUs'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.primaryIndigo,
            ),
          ),
          IconButton(
            onPressed: () => context.push('/wallet'),
            icon: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppTheme.primaryIndigo,
            ),
          ),
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(
              Icons.search_rounded,
              color: AppTheme.primaryIndigo,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.push('/dashboard'),
            child: userAsync.when(
              data: (user) => CircleAvatar(
                radius: 18,
                backgroundImage: user.profileImage != null
                    ? CachedNetworkImageProvider(user.profileImage!)
                    : const NetworkImage('https://i.pravatar.cc/150?u=me')
                          as ImageProvider,
              ),
              loading: () => const CircleAvatar(
                radius: 18,
                child: CircularProgressIndicator(),
              ),
              error: (_, __) =>
                  const CircleAvatar(radius: 18, child: Icon(Icons.person)),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const StoryTray(),
            const Divider(color: Colors.white10, height: 1),
            conversationsAsync.when(
              data: (conversations) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conv = conversations[index];
                  final currentUserId = userAsync.value?.id ?? "0";
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RepaintBoundary(
                      child:
                          GlassCard(
                                padding: const EdgeInsets.all(12),
                                child: ListTile(
                                  onTap: () => context.push('/chat/${conv.id}'),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: CachedNetworkImageProvider(
                                      conv.getDisplayAvatar(currentUserId),
                                    ),
                                  ),
                                  title: Text(
                                    conv.getDisplayTitle(currentUserId),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    conv.lastMessage ?? 'No messages yet',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                  trailing: conv.unreadCount > 0
                                      ? Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppTheme.primaryIndigo,
                                          ),
                                          child: Text(
                                            conv.unreadCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (index * 50).ms)
                              .slideY(begin: 0.1, end: 0),
                    ),
                  );
                },
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/feed'),
        backgroundColor: AppTheme.primaryIndigo,
        child: const Icon(Icons.public_rounded, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }
}
