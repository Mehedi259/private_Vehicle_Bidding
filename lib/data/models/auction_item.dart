class BidLog {
  final String bidderName;
  final double amount;
  final String timeAgo;

  const BidLog({
    required this.bidderName,
    required this.amount,
    required this.timeAgo,
  });

  factory BidLog.fromJson(Map<String, dynamic> json) {
    String parsedTimeAgo = 'Just now';
    if (json['placed_at'] != null) {
      try {
        final DateTime placed = DateTime.parse(json['placed_at']);
        final Duration diff = DateTime.now().difference(placed);
        if (diff.inDays > 0) {
          parsedTimeAgo = '${diff.inDays}d ago';
        } else if (diff.inHours > 0) {
          parsedTimeAgo = '${diff.inHours}h ago';
        } else if (diff.inMinutes > 0) {
          parsedTimeAgo = '${diff.inMinutes}m ago';
        }
      } catch (e) {
        parsedTimeAgo = json['placed_at'].toString();
      }
    }

    return BidLog(
      bidderName: json['bidder_name'] ?? 'Unknown',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      timeAgo: parsedTimeAgo,
    );
  }
}

class AuctionItem {
  final String id;
  final String title;
  final String imageUrl;
  final double currentBid;
  final int bidsCount;
  final String category;
  
  // Rich details fields
  final String subtitle;
  final String mileage;
  final String transmission;
  final String fuelType;
  final String description;
  final bool verifiedSeller;
  final bool vinVerified;
  final List<String> features;
  final List<BidLog> recentBids;
  final double? buyNowPrice;

  const AuctionItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.currentBid,
    required this.bidsCount,
    required this.category,
    this.subtitle = '',
    this.mileage = '',
    this.transmission = '',
    this.fuelType = '',
    this.description = '',
    this.verifiedSeller = false,
    this.vinVerified = false,
    this.features = const [],
    this.recentBids = const [],
    this.buyNowPrice,
  });

  factory AuctionItem.fromJson(Map<String, dynamic> json) {
    String primaryImage = '';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      final images = json['images'] as List;
      final primary = images.firstWhere((img) => img['is_primary'] == true, orElse: () => images.first);
      primaryImage = primary['image'] ?? '';
    }

    final seller = json['seller_details'] ?? {};

    return AuctionItem(
      id: json['id']?.toString() ?? '',
      title: '${json['year']} ${json['make']} ${json['model']}',
      imageUrl: primaryImage,
      currentBid: double.tryParse(json['current_highest_bid']?.toString() ?? '0') ?? 0.0,
      bidsCount: json['total_bids'] ?? 0,
      category: (json['vehicle_type']?.toString() ?? 'cars').toLowerCase(),
      subtitle: '${json['make']} ${json['model']}',
      mileage: '${json['mileage']} M',
      transmission: json['transmission'] ?? '',
      fuelType: json['fuel_type'] ?? '',
      description: json['description'] ?? '',
      verifiedSeller: seller['is_id_verified'] == true,
      vinVerified: json['is_vin_verified'] == true,
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      recentBids: (json['bids'] as List<dynamic>?)?.map((e) => BidLog.fromJson(e)).toList() ?? [],
      buyNowPrice: null, // Depending on if backend supports Buy It Now
    );
  }

  AuctionItem copyWith({
    String? id,
    String? title,
    String? imageUrl,
    double? currentBid,
    int? bidsCount,
    String? category,
    String? subtitle,
    String? mileage,
    String? transmission,
    String? fuelType,
    String? description,
    bool? verifiedSeller,
    bool? vinVerified,
    List<String>? features,
    List<BidLog>? recentBids,
    double? buyNowPrice,
  }) {
    return AuctionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      currentBid: currentBid ?? this.currentBid,
      bidsCount: bidsCount ?? this.bidsCount,
      category: category ?? this.category,
      subtitle: subtitle ?? this.subtitle,
      mileage: mileage ?? this.mileage,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      description: description ?? this.description,
      verifiedSeller: verifiedSeller ?? this.verifiedSeller,
      vinVerified: vinVerified ?? this.vinVerified,
      features: features ?? this.features,
      recentBids: recentBids ?? this.recentBids,
      buyNowPrice: buyNowPrice ?? this.buyNowPrice,
    );
  }
}
