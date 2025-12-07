// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  email: json['email'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  phoneNumber: json['phone_number'] as String?,
  profilePicture: json['profile_picture'] as String?,
  bio: json['bio'] as String?,
  followersCount: (json['followers_count'] as num?)?.toInt(),
  followingCount: (json['following_count'] as num?)?.toInt(),
  postsCount: (json['posts_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'phone_number': instance.phoneNumber,
  'profile_picture': instance.profilePicture,
  'bio': instance.bio,
  'followers_count': instance.followersCount,
  'following_count': instance.followingCount,
  'posts_count': instance.postsCount,
};
