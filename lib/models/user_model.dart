import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String username;
  
  // Email is not in the API response, make it optional
  final String? email;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'profile_picture')
  final String? profilePicture;

  final String? bio;

  @JsonKey(name: 'followers_count')
  final int? followersCount;

  @JsonKey(name: 'following_count')
  final int? followingCount;

  @JsonKey(name: 'posts_count')
  final int? postsCount;

  User({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profilePicture,
    this.bio,
    this.followersCount,
    this.followingCount,
    this.postsCount,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
