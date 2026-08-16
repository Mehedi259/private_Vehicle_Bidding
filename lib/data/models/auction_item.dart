class BidLog {
  final String bidderName;
  final double amount;
  final String timeAgo;

  const BidLog({
    required this.bidderName,
    required this.amount,
    required this.timeAgo,
  });
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
