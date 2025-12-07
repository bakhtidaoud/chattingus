import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../l10n/app_localizations.dart';
import '../controllers/feed_controller.dart';
import 'story_viewer_screen.dart';
import 'add_story_screen.dart';
import 'image_viewer_screen.dart';
import 'comments_screen.dart';
import 'user_profile_view_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final FeedController controller = Get.find<FeedController>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshFeed,
          child: CustomScrollView(
            slivers: [
              // Top Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.feed,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.send_outlined),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Stories Section
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      _StoryItem(name: l10n.yourStory, isUser: true),
                      const _StoryItem(
                        name: 'Clara',
                        imageUrl: 'https://i.pravatar.cc/150?u=clara',
                      ),
                      const _StoryItem(
                        name: 'Marcus',
                        imageUrl: 'https://i.pravatar.cc/150?u=marcus',
                      ),
                      const _StoryItem(
                        name: 'David',
                        imageUrl: 'https://i.pravatar.cc/150?u=david',
                      ),
                      const _StoryItem(
                        name: 'Sophia',
                        imageUrl: 'https://i.pravatar.cc/150?u=sophia',
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: Divider(height: 1)),

              // Posts Feed - Using real data from API
              Obx(() {
                if (controller.isLoading.value && controller.posts.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.posts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.errorMessage.value,
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.loadFeed,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.posts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No posts yet',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Follow users to see their posts',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = controller.posts[index];
                    return _PostItem(
                      post: post,
                      onLike: () => controller.likePost(post.id),
                      onComment: () {
                        // TODO: Navigate to comments screen
                      },
                    );
                  }, childCount: controller.posts.length),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isUser;

  const _StoryItem({required this.name, this.imageUrl, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isUser) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddStoryScreen()),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StoryViewerScreen(
                userName: name,
                userImageUrl: imageUrl ?? 'https://i.pravatar.cc/150?u=$name',
                timeAgo: '2h',
                storyImages: [
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
                  'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800',
                  'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=800',
                ],
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: SizedBox(
          width: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isUser
                          ? null
                          : const LinearGradient(
                              colors: [
                                Color(0xFFFF6B6B),
                                Color(0xFFFFD93D),
                                Color(0xFF6BCF7F),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : null,
                        backgroundColor: Colors.grey.shade300,
                        child: imageUrl == null && isUser
                            ? const Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
                  if (isUser)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: const TextStyle(fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostItem extends StatelessWidget {
  final dynamic post; // Can be Post model or keep flexible for now
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  const _PostItem({required this.post, this.onLike, this.onComment});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Extract data from post (works with Post model)
    final userName =
        post.author?.username ?? post.author?.firstName ?? 'Unknown';
    final userLocation = post.location ?? '';
    final userImageUrl = post.author?.profilePicture ?? '';
    final postImageUrl = post.image ?? '';
    final likesCount = post.likesCount ?? 0;
    final caption = post.caption ?? '';
    final commentCount = post.commentsCount ?? 0;
    final isLiked = post.isLiked ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Info Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: userImageUrl.isNotEmpty
                    ? NetworkImage(userImageUrl)
                    : null,
                backgroundColor: Colors.grey.shade300,
                child: userImageUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (userLocation.isNotEmpty)
                      Text(
                        userLocation,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
            ],
          ),
        ),

        // Post Image
        if (postImageUrl.isNotEmpty)
          Image.network(
            postImageUrl,
            width: double.infinity,
            height: 400,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 400,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 100, color: Colors.grey),
              );
            },
          ),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: onLike,
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: onComment,
              ),
              IconButton(
                icon: const Icon(Icons.send_outlined),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Likes Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '$likesCount ${l10n.likes.toLowerCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Caption
        if (caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$userName ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: caption),
                ],
              ),
            ),
          ),

        // View Comments
        if (commentCount > 0)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: GestureDetector(
              onTap: onComment,
              child: Text(
                l10n.viewAllComments(commentCount),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
          ),

        const SizedBox(height: 16),
      ],
    );
  }
}
