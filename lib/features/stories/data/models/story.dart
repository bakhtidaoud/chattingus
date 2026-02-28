class Story {
  final String id;
  final String authorName;
  final String authorImage;
  final String mediaUrl;
  final bool isVideo;
  final DateTime createdAt;
  final bool isViewed;

  Story({
    required this.id,
    required this.authorName,
    required this.authorImage,
    required this.mediaUrl,
    this.isVideo = false,
    required this.createdAt,
    this.isViewed = false,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'].toString(),
      authorName: json['author']['username'],
      authorImage:
          json['author']['profile_image'] ??
          'https://i.pravatar.cc/150?u=${json['author']['id']}',
      mediaUrl: json['media_url'] ?? json['media'],
      isVideo: json['is_video'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      isViewed: json['is_viewed'] ?? false,
    );
  }
}

class UserStories {
  final String userId;
  final String username;
  final String profileImage;
  final List<Story> stories;

  UserStories({
    required this.userId,
    required this.username,
    required this.profileImage,
    required this.stories,
  });

  bool get allViewed => stories.every((s) => s.isViewed);
}

class Highlight {
  final String id;
  final String title;
  final String coverImage;
  final List<Story> stories;

  Highlight({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.stories,
  });

  factory Highlight.fromJson(Map<String, dynamic> json) {
    return Highlight(
      id: json['id'].toString(),
      title: json['title'],
      coverImage: json['cover_image'],
      stories: (json['stories'] as List).map((s) => Story.fromJson(s)).toList(),
    );
  }
}
