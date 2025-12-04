import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class Chat {
  final int id;
  final String? name;

  @JsonKey(name: 'participants_usernames')
  final List<String> participantsUsernames;

  @JsonKey(name: 'last_message')
  final LastMessage? lastMessage;

  @JsonKey(name: 'is_group')
  final bool isGroup;

  Chat({
    required this.id,
    this.name,
    required this.participantsUsernames,
    this.lastMessage,
    required this.isGroup,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

@JsonSerializable()
class LastMessage {
  final String content;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  LastMessage({required this.content, required this.createdAt});

  factory LastMessage.fromJson(Map<String, dynamic> json) =>
      _$LastMessageFromJson(json);

  Map<String, dynamic> toJson() => _$LastMessageToJson(this);
}
