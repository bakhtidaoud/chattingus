import 'package:flutter/material.dart';
import '../models/search_models.dart';

/// User search result tile
class UserSearchTile extends StatelessWidget {
  final UserSearchResult user;
  final VoidCallback onTap;

  const UserSearchTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: user.profilePicture != null
            ? NetworkImage(user.profilePicture!)
            : null,
        child: user.profilePicture == null
            ? Text(
                user.username[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              user.username,
              style: const TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (user.isVerified) ...[
            const SizedBox(width: 4),
            const Icon(Icons.verified, size: 16, color: Colors.blue),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (user.fullName.isNotEmpty)
            Text(
              user.fullName,
              style: TextStyle(color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
            ),
          if (user.bio != null && user.bio!.isNotEmpty)
            Text(
              user.bio!,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      trailing: user.isPrivate
          ? Icon(Icons.lock, size: 16, color: Colors.grey[600])
          : null,
    );
  }
}

/// Post search result tile
class PostSearchTile extends StatelessWidget {
  final PostSearchResult post;
  final VoidCallback onTap;

  const PostSearchTile({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: post.image != null
                  ? Image.network(
                      post.image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, color: Colors.grey),
                        );
                      },
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 12),
            // Post info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: post.user.profilePicture != null
                            ? NetworkImage(post.user.profilePicture!)
                            : null,
                        child: post.user.profilePicture == null
                            ? Text(
                                post.user.username[0].toUpperCase(),
                                style: const TextStyle(fontSize: 10),
                              )
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          post.user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Caption
                  if (post.caption != null && post.caption!.isNotEmpty)
                    Text(
                      post.caption!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  // Stats
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.likesCount}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.comment_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post.commentsCount}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reel search result tile
class ReelSearchTile extends StatelessWidget {
  final ReelSearchResult reel;
  final VoidCallback onTap;

  const ReelSearchTile({super.key, required this.reel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reel thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: reel.thumbnail != null
                      ? Image.network(
                          reel.thumbnail!,
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.video_library,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: 60,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.video_library,
                            color: Colors.grey,
                          ),
                        ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 10,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          _formatViews(reel.viewsCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Reel info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: reel.user.profilePicture != null
                            ? NetworkImage(reel.user.profilePicture!)
                            : null,
                        child: reel.user.profilePicture == null
                            ? Text(
                                reel.user.username[0].toUpperCase(),
                                style: const TextStyle(fontSize: 10),
                              )
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          reel.user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Caption
                  if (reel.caption != null && reel.caption!.isNotEmpty)
                    Text(
                      reel.caption!,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  // Stats
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reel.likesCount}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatViews(reel.viewsCount),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }
}

/// Hashtag search result tile
class HashtagSearchTile extends StatelessWidget {
  final HashtagSearchResult hashtag;
  final VoidCallback onTap;

  const HashtagSearchTile({
    super.key,
    required this.hashtag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.tag, color: Colors.grey),
      ),
      title: Text(
        '#${hashtag.name}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${hashtag.totalCount} posts',
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
    );
  }
}

/// Empty state widget
class SearchEmptyState extends StatelessWidget {
  final String message;
  final String? suggestion;

  const SearchEmptyState({
    super.key,
    this.message = 'No results found',
    this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (suggestion != null) ...[
              const SizedBox(height: 8),
              Text(
                suggestion!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class SearchErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SearchErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
