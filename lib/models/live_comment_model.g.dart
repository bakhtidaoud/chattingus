// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveComment _$LiveCommentFromJson(Map<String, dynamic> json) => LiveComment(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  username: json['username'] as String,
  userAvatar: json['user_avatar'] as String?,
  text: json['text'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$LiveCommentToJson(LiveComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'username': instance.username,
      'user_avatar': instance.userAvatar,
      'text': instance.text,
      'created_at': instance.createdAt.toIso8601String(),
    };
