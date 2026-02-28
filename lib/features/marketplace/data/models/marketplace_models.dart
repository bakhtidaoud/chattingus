class Category {
  final String id;
  final String name;
  final String? icon;
  final String? parentId;

  Category({required this.id, required this.name, this.icon, this.parentId});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      icon: json['icon'],
      parentId: json['parent_id']?.toString(),
    );
  }
}

class Attribute {
  final String id;
  final String name;
  final dynamic value;

  Attribute({required this.id, required this.name, required this.value});

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'].toString(),
      name: json['definition']['name'],
      value: json['value'],
    );
  }
}

class Listing {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currency;
  final List<String> images;
  final Category category;
  final List<Attribute> attributes;
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final bool shippingAvailable;
  final bool localPickup;
  final bool isFeatured;
  final DateTime createdAt;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.images,
    required this.category,
    required this.attributes,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.shippingAvailable,
    required this.localPickup,
    this.isFeatured = false,
    required this.createdAt,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      currency: json['currency'] ?? 'USD',
      images: List<String>.from(json['images'] ?? []),
      category: Category.fromJson(json['category']),
      attributes: (json['attributes'] as List? ?? [])
          .map((a) => Attribute.fromJson(a))
          .toList(),
      sellerId: json['seller']['id'].toString(),
      sellerName: json['seller']['username'],
      sellerImage:
          json['seller']['profile_image'] ??
          'https://i.pravatar.cc/150?u=${json['seller']['id']}',
      shippingAvailable: json['shipping_available'] ?? false,
      localPickup: json['local_pickup'] ?? true,
      isFeatured: json['is_featured'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class Offer {
  final String id;
  final String listingId;
  final double amount;
  final double? counteredAmount;
  final String status; // pending, accepted, rejected, countered
  final DateTime createdAt;

  Offer({
    required this.id,
    required this.listingId,
    required this.amount,
    this.counteredAmount,
    required this.status,
    required this.createdAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'].toString(),
      listingId: json['listing'].toString(),
      amount: double.parse(json['amount'].toString()),
      counteredAmount: json['countered_amount'] != null
          ? double.parse(json['countered_amount'].toString())
          : null,
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
