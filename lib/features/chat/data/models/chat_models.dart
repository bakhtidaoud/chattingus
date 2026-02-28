class Conversation {
  final String id;
  final String? title;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool isGroup;
  final List<Participant> participants;
  final int unreadCount;
  final String? groupAvatar;

  Conversation({
    required this.id,
    this.title,
    this.lastMessage,
    this.lastMessageTime,
    this.isGroup = false,
    required this.participants,
    this.unreadCount = 0,
    this.groupAvatar,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'].toString(),
      title: json['title'],
      lastMessage: json['last_message']?['content'],
      lastMessageTime: json['last_message'] != null
          ? DateTime.parse(json['last_message']['created_at'])
          : null,
      isGroup: json['is_group'] ?? false,
      participants: (json['participants'] as List)
          .map((p) => Participant.fromJson(p))
          .toList(),
      unreadCount: json['unread_count'] ?? 0,
      groupAvatar: json['group_avatar'],
    );
  }

  String getDisplayTitle(String currentUserId) {
    if (isGroup && title != null) return title!;
    final other = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => participants.first,
    );
    return other.username;
  }

  String getDisplayAvatar(String currentUserId) {
    if (isGroup && groupAvatar != null) return groupAvatar!;
    final other = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => participants.first,
    );
    return other.profileImage ?? 'https://i.pravatar.cc/150?u=${other.id}';
  }
}

class Participant {
  final String id;
  final String username;
  final String? profileImage;
  final bool isAdmin;

  Participant({
    required this.id,
    required this.username,
    this.profileImage,
    this.isAdmin = false,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'].toString(),
      username: json['username'],
      profileImage: json['profile_image'],
      isAdmin: json['is_admin'] ?? false,
    );
  }
}

class Message {
  final String id;
  final String senderId;
  final String content;
  final String? attachmentUrl;
  final String? attachmentType;
  final DateTime createdAt;
  final bool isMe;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    this.attachmentUrl,
    this.attachmentType,
    required this.createdAt,
    this.isMe = false,
  });

  factory Message.fromJson(Map<String, dynamic> json, String currentUserId) {
    return Message(
      id: json['id'].toString(),
      senderId: json['sender_id'].toString(),
      content: json['content'] ?? '',
      attachmentUrl: json['attachment'],
      attachmentType: json['attachment_type'],
      createdAt: DateTime.parse(json['created_at']),
      isMe: json['sender_id'].toString() == currentUserId,
    );
  }
}
