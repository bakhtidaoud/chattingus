import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../data/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommentSheet extends StatelessWidget {
  final String postId;

  const CommentSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.midnight.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(color: Colors.white10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Mock data
              itemBuilder: (context, index) {
                return _CommentWidget(
                  comment: Comment(
                    id: 'c$index',
                    authorName: 'User $index',
                    authorImage: 'https://i.pravatar.cc/150?u=c$index',
                    content:
                        'This is a premium comment with @mention and great insights! 🔥',
                    createdAt: DateTime.now(),
                    replies: index == 0
                        ? [
                            Comment(
                              id: 'r1',
                              authorName: 'Replier',
                              authorImage: 'https://i.pravatar.cc/150?u=r1',
                              content: 'I totally agree! #ChattingUs',
                              createdAt: DateTime.now(),
                            ),
                          ]
                        : [],
                  ),
                );
              },
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      decoration: const BoxDecoration(
        color: AppTheme.midnight,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me'),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: GlassTextField(
              hintText: 'Add a comment...',
              prefixIcon: Icons.chat_bubble_outline,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: AppTheme.primaryIndigo),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _CommentWidget extends StatelessWidget {
  final Comment comment;
  final bool isReply;

  const _CommentWidget({required this.comment, this.isReply = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, left: isReply ? 40 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: isReply ? 12 : 18,
                backgroundImage: CachedNetworkImageProvider(
                  comment.authorImage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(comment.content, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '2h',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment.replies.isNotEmpty)
            ...comment.replies
                .map((r) => _CommentWidget(comment: r, isReply: true))
                .toList(),
        ],
      ),
    );
  }
}
