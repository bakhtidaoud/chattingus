import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class Comment {
  final int id;
  final User author;
  final String text;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
