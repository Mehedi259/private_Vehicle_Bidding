enum VehicleStatus {
  active,
  sold,
}

class ListedVehicle {
  final String id;
  final String title;
  final String imageUrl;
  final double lastBid;
  final int bidsCount;
  final VehicleStatus status;
  final double? buyNowPrice;

  const ListedVehicle({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.lastBid,
    required this.bidsCount,
    required this.status,
    this.buyNowPrice,
  });

  ListedVehicle copyWith({
    String? id,
    String? title,
    String? imageUrl,
    double? lastBid,
    int? bidsCount,
    VehicleStatus? status,
    double? buyNowPrice,
  }) {
    return ListedVehicle(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      lastBid: lastBid ?? this.lastBid,
      bidsCount: bidsCount ?? this.bidsCount,
      status: status ?? this.status,
      buyNowPrice: buyNowPrice ?? this.buyNowPrice,
    );
  }
}
