import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class Post {
  final int id;

  @JsonKey(name: 'user')
  final User author;

  final String caption;
  final String? image;
  final String? location;

  @JsonKey(name: 'likes_count')
  final int likesCount;

  @JsonKey(name: 'comments_count')
  final int commentsCount;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'is_liked')
  final bool isLiked;

  Post({
    required this.id,
    required this.author,
    required this.caption,
    this.image,
    this.location,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    required this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
