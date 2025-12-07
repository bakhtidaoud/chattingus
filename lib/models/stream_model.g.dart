// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StreamModel _$StreamModelFromJson(Map<String, dynamic> json) => StreamModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  broadcasterId: (json['broadcaster_id'] as num).toInt(),
  broadcasterName: json['broadcaster_name'] as String,
  broadcasterAvatar: json['broadcaster_avatar'] as String?,
  isActive: json['is_active'] as bool,
  viewerCount: (json['viewer_count'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
);

Map<String, dynamic> _$StreamModelToJson(StreamModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'broadcaster_id': instance.broadcasterId,
      'broadcaster_name': instance.broadcasterName,
      'broadcaster_avatar': instance.broadcasterAvatar,
      'is_active': instance.isActive,
      'viewer_count': instance.viewerCount,
      'created_at': instance.createdAt.toIso8601String(),
      'started_at': instance.startedAt?.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
    };
