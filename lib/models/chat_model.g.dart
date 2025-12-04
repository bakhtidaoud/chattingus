// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  participantsUsernames: (json['participants_usernames'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  lastMessage: json['last_message'] == null
      ? null
      : LastMessage.fromJson(json['last_message'] as Map<String, dynamic>),
  isGroup: json['is_group'] as bool,
);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'participants_usernames': instance.participantsUsernames,
  'last_message': instance.lastMessage,
  'is_group': instance.isGroup,
};

LastMessage _$LastMessageFromJson(Map<String, dynamic> json) => LastMessage(
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$LastMessageToJson(LastMessage instance) =>
    <String, dynamic>{
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
    };
