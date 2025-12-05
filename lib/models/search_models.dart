import 'package:json_annotation/json_annotation.dart';

part 'search_models.g.dart';

/// Container for all search results
@JsonSerializable()
class SearchResult {
  final List<UserSearchResult> users;
  final List<PostSearchResult> posts;
  final List<ReelSearchResult> reels;
  final List<HashtagSearchResult> hashtags;

  SearchResult({
    this.users = const [],
    this.posts = const [],
    this.reels = const [],
    this.hashtags = const [],
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  bool get isEmpty =>
      users.isEmpty && posts.isEmpty && reels.isEmpty && hashtags.isEmpty;
}

/// User search result model
@JsonSerializable()
class UserSearchResult {
  final int id;
  final String username;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String? bio;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @JsonKey(name: 'is_private')
  final bool isPrivate;

  UserSearchResult({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.bio,
    this.profilePicture,
    this.isVerified = false,
    this.isPrivate = false,
  });

  factory UserSearchResult.fromJson(Map<String, dynamic> json) =>
      _$UserSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$UserSearchResultToJson(this);

  String get fullName => '$firstName $lastName'.trim();
}

/// Nested user info for posts and reels
@JsonSerializable()
class SearchUserInfo {
  final int id;
  final String username;
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;

  SearchUserInfo({
    required this.id,
    required this.username,
    this.profilePicture,
  });

  factory SearchUserInfo.fromJson(Map<String, dynamic> json) =>
      _$SearchUserInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SearchUserInfoToJson(this);
}

/// Post search result model
@JsonSerializable()
class PostSearchResult {
  final int id;
  final SearchUserInfo user;
  final String? image;
  final String? caption;
  final String? location;
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @JsonKey(name: 'comments_count')
  final int commentsCount;
  @JsonKey(name: 'created_at')
  final String createdAt;

  PostSearchResult({
    required this.id,
    required this.user,
    this.image,
    this.caption,
    this.location,
    this.likesCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });

  factory PostSearchResult.fromJson(Map<String, dynamic> json) =>
      _$PostSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$PostSearchResultToJson(this);
}

/// Reel search result model
@JsonSerializable()
class ReelSearchResult {
  final int id;
  final SearchUserInfo user;
  final String? video;
  final String? thumbnail;
  final String? caption;
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @JsonKey(name: 'views_count')
  final int viewsCount;
  @JsonKey(name: 'created_at')
  final String createdAt;

  ReelSearchResult({
    required this.id,
    required this.user,
    this.video,
    this.thumbnail,
    this.caption,
    this.likesCount = 0,
    this.viewsCount = 0,
    required this.createdAt,
  });

  factory ReelSearchResult.fromJson(Map<String, dynamic> json) =>
      _$ReelSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$ReelSearchResultToJson(this);
}

/// Hashtag search result model
@JsonSerializable()
class HashtagSearchResult {
  final int id;
  final String name;
  @JsonKey(name: 'posts_count')
  final int postsCount;
  @JsonKey(name: 'reels_count')
  final int reelsCount;

  HashtagSearchResult({
    required this.id,
    required this.name,
    this.postsCount = 0,
    this.reelsCount = 0,
  });

  factory HashtagSearchResult.fromJson(Map<String, dynamic> json) =>
      _$HashtagSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$HashtagSearchResultToJson(this);

  int get totalCount => postsCount + reelsCount;
}
