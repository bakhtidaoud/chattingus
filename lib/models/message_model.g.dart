// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: (json['id'] as num).toInt(),
  senderUsername: json['sender_username'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  isRead: json['is_read'] as bool,
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'sender_username': instance.senderUsername,
  'content': instance.content,
  'created_at': instance.createdAt.toIso8601String(),
  'is_read': instance.isRead,
};
