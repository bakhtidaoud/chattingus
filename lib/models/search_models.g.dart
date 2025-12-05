// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
  users:
      (json['users'] as List<dynamic>?)
          ?.map((e) => UserSearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  posts:
      (json['posts'] as List<dynamic>?)
          ?.map((e) => PostSearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  reels:
      (json['reels'] as List<dynamic>?)
          ?.map((e) => ReelSearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  hashtags:
      (json['hashtags'] as List<dynamic>?)
          ?.map((e) => HashtagSearchResult.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) =>
    <String, dynamic>{
      'users': instance.users,
      'posts': instance.posts,
      'reels': instance.reels,
      'hashtags': instance.hashtags,
    };

UserSearchResult _$UserSearchResultFromJson(Map<String, dynamic> json) =>
    UserSearchResult(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      bio: json['bio'] as String?,
      profilePicture: json['profile_picture'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isPrivate: json['is_private'] as bool? ?? false,
    );

Map<String, dynamic> _$UserSearchResultToJson(UserSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'bio': instance.bio,
      'profile_picture': instance.profilePicture,
      'is_verified': instance.isVerified,
      'is_private': instance.isPrivate,
    };

SearchUserInfo _$SearchUserInfoFromJson(Map<String, dynamic> json) =>
    SearchUserInfo(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      profilePicture: json['profile_picture'] as String?,
    );

Map<String, dynamic> _$SearchUserInfoToJson(SearchUserInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profile_picture': instance.profilePicture,
    };

PostSearchResult _$PostSearchResultFromJson(Map<String, dynamic> json) =>
    PostSearchResult(
      id: (json['id'] as num).toInt(),
      user: SearchUserInfo.fromJson(json['user'] as Map<String, dynamic>),
      image: json['image'] as String?,
      caption: json['caption'] as String?,
      location: json['location'] as String?,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$PostSearchResultToJson(PostSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'image': instance.image,
      'caption': instance.caption,
      'location': instance.location,
      'likes_count': instance.likesCount,
      'comments_count': instance.commentsCount,
      'created_at': instance.createdAt,
    };

ReelSearchResult _$ReelSearchResultFromJson(Map<String, dynamic> json) =>
    ReelSearchResult(
      id: (json['id'] as num).toInt(),
      user: SearchUserInfo.fromJson(json['user'] as Map<String, dynamic>),
      video: json['video'] as String?,
      thumbnail: json['thumbnail'] as String?,
      caption: json['caption'] as String?,
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$ReelSearchResultToJson(ReelSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'video': instance.video,
      'thumbnail': instance.thumbnail,
      'caption': instance.caption,
      'likes_count': instance.likesCount,
      'views_count': instance.viewsCount,
      'created_at': instance.createdAt,
    };

HashtagSearchResult _$HashtagSearchResultFromJson(Map<String, dynamic> json) =>
    HashtagSearchResult(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      postsCount: (json['posts_count'] as num?)?.toInt() ?? 0,
      reelsCount: (json['reels_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$HashtagSearchResultToJson(
  HashtagSearchResult instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'posts_count': instance.postsCount,
  'reels_count': instance.reelsCount,
};
