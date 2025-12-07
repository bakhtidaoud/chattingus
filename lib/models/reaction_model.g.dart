// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionModel _$ReactionModelFromJson(Map<String, dynamic> json) =>
    ReactionModel(
      type: json['type'] as String,
      userId: (json['user_id'] as num).toInt(),
      username: json['username'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ReactionModelToJson(ReactionModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'user_id': instance.userId,
      'username': instance.username,
      'timestamp': instance.timestamp.toIso8601String(),
    };
