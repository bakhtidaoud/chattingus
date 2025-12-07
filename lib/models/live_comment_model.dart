import 'package:json_annotation/json_annotation.dart';

part 'live_comment_model.g.dart';

@JsonSerializable()
class LiveComment {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String username;
  @JsonKey(name: 'user_avatar')
  final String? userAvatar;
  final String text;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  LiveComment({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.text,
    required this.createdAt,
  });

  factory LiveComment.fromJson(Map<String, dynamic> json) =>
      _$LiveCommentFromJson(json);

  Map<String, dynamic> toJson() => _$LiveCommentToJson(this);
}
