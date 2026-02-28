class Post {
  final String id;
  final String authorName;
  final String authorImage;
  final String caption;
  final String? mediaUrl;
  final bool isVideo;
  final int reactionsCount;
  final int commentsCount;
  final bool isReacted;
  final bool isSaved;
  final DateTime createdAt;
  final List<String> hashtags;

  Post({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.caption,
    this.mediaUrl,
    this.isVideo = false,
    this.reactionsCount = 0,
    this.commentsCount = 0,
    this.isReacted = false,
    this.isSaved = false,
    required this.createdAt,
    this.hashtags = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      authorName: json['author']['username'],
      authorImage:
          json['author']['profile_image'] ??
          'https://i.pravatar.cc/150?u=${json['author']['id']}',
      caption: json['caption'] ?? '',
      mediaUrl: json['media'],
      isVideo: json['is_video'] ?? false,
      reactionsCount: json['reactions_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isReacted: json['is_reacted'] ?? false,
      isSaved: json['is_saved'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      hashtags: List<String>.from(json['hashtags'] ?? []),
    );
  }
}

class Comment {
  final String id;
  final String authorName;
  final String authorImage;
  final String content;
  final DateTime createdAt;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.content,
    required this.createdAt,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'].toString(),
      authorName: json['author']['username'],
      authorImage:
          json['author']['profile_image'] ??
          'https://i.pravatar.cc/150?u=${json['author']['id']}',
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      replies: json['replies'] != null
          ? (json['replies'] as List).map((i) => Comment.fromJson(i)).toList()
          : [],
    );
  }
}
