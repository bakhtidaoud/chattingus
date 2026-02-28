import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/story_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoryTray extends ConsumerWidget {
  const StoryTray({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(followingStoriesProvider);

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: storiesAsync.when(
        data: (userStories) => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: userStories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _buildAddStory(context);

            final userStory = userStories[index - 1];
            return _StoryCircle(userStories: userStory);
          },
        ),
        loading: () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 5,
          itemBuilder: (context, index) => _buildShimmer(),
        ),
        error: (e, st) =>
            const Center(child: Icon(Icons.error_outline, color: Colors.red)),
      ),
    );
  }

  Widget _buildAddStory(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white24,
                  size: 32,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryIndigo,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Your Story',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    ).animate().scale();
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 8,
            color: Colors.white.withOpacity(0.05),
          ),
        ],
      ),
    );
  }
}

class _StoryCircle extends StatelessWidget {
  final dynamic userStories; // UserStories model

  const _StoryCircle({required this.userStories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () => context.push('/story-player', extra: userStories),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: userStories.allViewed
                    ? null
                    : const LinearGradient(
                        colors: [
                          AppTheme.primaryIndigo,
                          AppTheme.electricViolet,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                border: userStories.allViewed
                    ? Border.all(color: Colors.white10)
                    : null,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppTheme.midnight,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(
                    userStories.profileImage,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userStories.username,
              style: const TextStyle(fontSize: 11, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1, end: 0);
  }
}
