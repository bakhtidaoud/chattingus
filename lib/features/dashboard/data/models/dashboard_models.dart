class DashboardStats {
  final int totalPosts;
  final int totalFollowers;
  final int totalFollowing;
  final int activeListings;
  final double walletBalance;
  final int unreadNotifications;
  final List<ActivityTrend> activityTrends;

  DashboardStats({
    required this.totalPosts,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.activeListings,
    required this.walletBalance,
    required this.unreadNotifications,
    required this.activityTrends,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalPosts: json['total_posts'] ?? 0,
      totalFollowers: json['total_followers'] ?? 0,
      totalFollowing: json['total_following'] ?? 0,
      activeListings: json['active_listings'] ?? 0,
      walletBalance: double.parse((json['wallet_balance'] ?? 0).toString()),
      unreadNotifications: json['unread_notifications'] ?? 0,
      activityTrends: (json['activity_trends'] as List? ?? [])
          .map((t) => ActivityTrend.fromJson(t))
          .toList(),
    );
  }
}

class ActivityTrend {
  final String date;
  final int count;

  ActivityTrend({required this.date, required this.count});

  factory ActivityTrend.fromJson(Map<String, dynamic> json) {
    return ActivityTrend(date: json['date'], count: json['count']);
  }
}
