class UserProfile {
  final String id;
  final String username;
  final String email;
  final String? profileImage;
  final String? bio;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.profileImage,
    this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'].toString(),
      username: json['username'],
      email: json['email'],
      profileImage: json['profile_image'],
      bio: json['bio'],
    );
  }
}

class AuthToken {
  final String access;
  final String refresh;

  AuthToken({required this.access, required this.refresh});
}
