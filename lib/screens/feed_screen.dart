import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'story_viewer_screen.dart';
import 'add_story_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
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

            // Posts Feed
            SliverList(
              delegate: SliverChildListDelegate([
                _PostItem(
                  userName: 'John Doe',
                  userLocation: 'San Francisco, CA',
                  userImageUrl: 'https://i.pravatar.cc/150?u=johndoe',
                  postImageUrl:
                      'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800',
                  likes: '1,234',
                  caption: l10n.workingOnProject,
                  commentCount: 56,
                ),
                _PostItem(
                  userName: 'Sarah Miller',
                  userLocation: 'New York, NY',
                  userImageUrl: 'https://i.pravatar.cc/150?u=sarahmiller',
                  postImageUrl:
                      'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=800',
                  likes: '892',
                  caption: 'Beautiful sunset at the beach 🌅',
                  commentCount: 23,
                ),
                _PostItem(
                  userName: 'Alex Chen',
                  userLocation: 'Los Angeles, CA',
                  userImageUrl: 'https://i.pravatar.cc/150?u=alexchen',
                  postImageUrl:
                      'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=800',
                  likes: '2,145',
                  caption: 'Code never lies, comments sometimes do 💻',
                  commentCount: 89,
                ),
              ]),
            ),
          ],
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
                        radius: 32,
                        backgroundImage: imageUrl != null
                            ? NetworkImage(imageUrl!)
                            : null,
                        backgroundColor: Colors.grey.shade300,
                        child: imageUrl == null && isUser
                            ? const Icon(
                                Icons.person,
                                size: 32,
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
  final String userName;
  final String userLocation;
  final String userImageUrl;
  final String postImageUrl;
  final String likes;
  final String caption;
  final int commentCount;

  const _PostItem({
    required this.userName,
    required this.userLocation,
    required this.userImageUrl,
    required this.postImageUrl,
    required this.likes,
    required this.caption,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                backgroundImage: NetworkImage(userImageUrl),
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
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {},
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
            '$likes ${l10n.likes.toLowerCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Caption
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: GestureDetector(
            onTap: () {},
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
