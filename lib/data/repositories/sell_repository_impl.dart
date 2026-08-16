import '../../core/constants/custom_assets.dart';
import '../../core/interfaces/i_sell_repository.dart';
import '../models/listed_vehicle.dart';

class SellRepositoryImpl implements ISellRepository {
  final List<ListedVehicle> _mockListings = [
    const ListedVehicle(
      id: '1',
      title: '2022 Ford F-150 XLT',
      imageUrl: CustomAssets.fordF150,
      lastBid: 18500.0,
      bidsCount: 43,
      status: VehicleStatus.sold,
    ),
  ];

  @override
  Future<List<ListedVehicle>> getListedVehicles() async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockListings);
  }

  @override
  Future<ListedVehicle> addListedVehicle(ListedVehicle vehicle) async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 200));
    _mockListings.add(vehicle);
    return vehicle;
  }
}
