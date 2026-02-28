class Wallet {
  final double balance;
  final String currency;
  final List<WalletTransaction> transactions;

  Wallet({
    required this.balance,
    required this.currency,
    required this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: double.parse(json['balance'].toString()),
      currency: json['currency'] ?? 'USD',
      transactions: (json['transactions'] as List? ?? [])
          .map((t) => WalletTransaction.fromJson(t))
          .toList(),
    );
  }
}

class WalletTransaction {
  final String id;
  final double amount;
  final String type; // DEPOSIT, WITHDRAWAL, PAYMENT, REFUND
  final String status;
  final String description;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'].toString(),
      amount: double.parse(json['amount'].toString()),
      type: json['transaction_type'],
      status: json['status'],
      description: json['description'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Order {
  final String id;
  final String listingTitle;
  final String listingImage;
  final double amount;
  final String status; // PAID, SHIPPED, DELIVERED, COMPLETED, DISPUTED
  final String? trackingNumber;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.listingTitle,
    required this.listingImage,
    required this.amount,
    required this.status,
    this.trackingNumber,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      listingTitle: json['listing']['title'],
      listingImage: (json['listing']['images'] as List).isNotEmpty
          ? json['listing']['images'][0]
          : 'https://via.placeholder.com/150',
      amount: double.parse(json['total_amount'].toString()),
      status: json['status'],
      trackingNumber: json['tracking_number'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ReferralStat {
  final int totalReferred;
  final double totalRewards;
  final List<ReferredUser> referredUsers;

  ReferralStat({
    required this.totalReferred,
    required this.totalRewards,
    required this.referredUsers,
  });

  factory ReferralStat.fromJson(Map<String, dynamic> json) {
    return ReferralStat(
      totalReferred: json['total_count'],
      totalRewards: double.parse(json['total_rewards'].toString()),
      referredUsers: (json['users'] as List? ?? [])
          .map((u) => ReferredUser.fromJson(u))
          .toList(),
    );
  }
}

class ReferredUser {
  final String username;
  final DateTime joinedAt;
  final bool isVerified;

  ReferredUser({
    required this.username,
    required this.joinedAt,
    required this.isVerified,
  });

  factory ReferredUser.fromJson(Map<String, dynamic> json) {
    return ReferredUser(
      username: json['username'],
      joinedAt: DateTime.parse(json['date_joined']),
      isVerified: json['is_verified'] ?? false,
    );
  }
}
