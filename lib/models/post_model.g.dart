// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: (json['id'] as num).toInt(),
  author: User.fromJson(json['user'] as Map<String, dynamic>),
  caption: json['caption'] as String,
  image: json['image'] as String?,
  location: json['location'] as String?,
  likesCount: (json['likes_count'] as num).toInt(),
  commentsCount: (json['comments_count'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  isLiked: json['is_liked'] as bool,
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'user': instance.author,
  'caption': instance.caption,
  'image': instance.image,
  'location': instance.location,
  'likes_count': instance.likesCount,
  'comments_count': instance.commentsCount,
  'created_at': instance.createdAt.toIso8601String(),
  'is_liked': instance.isLiked,
};
