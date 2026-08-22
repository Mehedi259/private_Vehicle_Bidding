import 'dart:convert';

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
  final List<String> images;
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

  // Location fields
  final String country;
  final String state;
  final String city;
  final String zipCode;
  
  // Timing
  final DateTime? endTime;

  const AuctionItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.images = const [],
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
    this.country = '',
    this.state = '',
    this.city = '',
    this.zipCode = '',
    this.endTime,
  });

  factory AuctionItem.fromJson(Map<String, dynamic> json) {
    String primaryImage = '';
    List<String> allImages = [];
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      final imagesList = json['images'] as List;
      final primary = imagesList.firstWhere((img) => img['is_primary'] == true, orElse: () => imagesList.first);
      primaryImage = primary['image'] ?? '';
      allImages = imagesList.map((img) => img['image']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }

    final seller = json['seller_details'] ?? {};

    List<String> parsedFeatures = [];
    if (json['features'] != null) {
      if (json['features'] is String) {
        try {
          final decoded = jsonDecode(json['features']) as List;
          parsedFeatures = decoded.map((e) => e.toString()).toList();
        } catch (_) {
          // If decoding fails, just add the string itself or leave empty
        }
      } else if (json['features'] is List) {
        parsedFeatures = (json['features'] as List).map((e) => e.toString()).toList();
      }
    }

    return AuctionItem(
      id: json['id']?.toString() ?? '',
      title: '${json['year']} ${json['make']} ${json['model']}',
      imageUrl: primaryImage,
      images: allImages,
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
      features: parsedFeatures,
      recentBids: (json['bids'] as List<dynamic>?)?.map((e) => BidLog.fromJson(e)).toList() ?? [],
      buyNowPrice: double.tryParse(json['buy_now_price']?.toString() ?? ''),
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      zipCode: json['zip_code']?.toString() ?? '',
      endTime: json['end_time'] != null ? DateTime.tryParse(json['end_time']) : null,
    );
  }

  AuctionItem copyWith({
    String? id,
    String? title,
    String? imageUrl,
    List<String>? images,
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
      images: images ?? this.images,
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
