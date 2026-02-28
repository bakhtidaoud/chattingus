class AppNotification {
  final String id;
  final String title;
  final String message;
  final String type; // LIKE, COMMENT, FOLLOW, ORDER_STATUS, PRICE_ALERT
  final bool isRead;
  final DateTime createdAt;
  final String? relatedId;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'].toString(),
      title: json['title'] ?? 'Notification',
      message: json['message'] ?? '',
      type: json['notification_type'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      relatedId: json['related_id']?.toString(),
    );
  }
}
