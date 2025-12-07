import 'package:json_annotation/json_annotation.dart';

part 'stream_model.g.dart';

@JsonSerializable()
class StreamModel {
  final int id;
  final String title;
  final String? description;
  @JsonKey(name: 'broadcaster_id')
  final int broadcasterId;
  @JsonKey(name: 'broadcaster_name')
  final String broadcasterName;
  @JsonKey(name: 'broadcaster_avatar')
  final String? broadcasterAvatar;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'viewer_count')
  final int viewerCount;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;

  StreamModel({
    required this.id,
    required this.title,
    this.description,
    required this.broadcasterId,
    required this.broadcasterName,
    this.broadcasterAvatar,
    required this.isActive,
    required this.viewerCount,
    required this.createdAt,
    this.startedAt,
    this.endedAt,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) =>
      _$StreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$StreamModelToJson(this);
}
