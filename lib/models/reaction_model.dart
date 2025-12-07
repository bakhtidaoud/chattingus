import 'package:json_annotation/json_annotation.dart';

part 'reaction_model.g.dart';

@JsonSerializable()
class ReactionModel {
  final String type; // 'like', 'love', 'fire', 'wow', etc.
  @JsonKey(name: 'user_id')
  final int userId;
  final String username;
  final DateTime timestamp;

  ReactionModel({
    required this.type,
    required this.userId,
    required this.username,
    required this.timestamp,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) =>
      _$ReactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReactionModelToJson(this);
}
