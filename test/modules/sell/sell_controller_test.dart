import 'package:flutter_test/flutter_test.dart';
import 'package:private_vehicle_bidding/core/interfaces/i_sell_repository.dart';
import 'package:private_vehicle_bidding/data/models/listed_vehicle.dart';
import 'package:private_vehicle_bidding/modules/sell/controllers/sell_controller.dart';

class MockSellRepository implements ISellRepository {
  final List<ListedVehicle> vehicles = [];
  bool shouldFail = false;

  @override
  Future<List<ListedVehicle>> getListedVehicles() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      throw Exception('Database error');
    }
    return vehicles;
  }

  @override
  Future<ListedVehicle> addListedVehicle(ListedVehicle vehicle) async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      throw Exception('Network timeout');
    }
    vehicles.add(vehicle);
    return vehicle;
  }
}

void main() {
  late MockSellRepository mockRepo;
  late SellController controller;

  setUp(() {
    mockRepo = MockSellRepository();
    // Setup initial data in mock repo
    mockRepo.vehicles.addAll([
      const ListedVehicle(
        id: '1',
        title: '2022 Ford F-150',
        imageUrl: 'assets/images/ford_f150.png',
        lastBid: 18500.0,
        bidsCount: 43,
        status: VehicleStatus.sold,
      ),
      const ListedVehicle(
        id: '2',
        title: '2023 Tesla Model Y',
        imageUrl: 'assets/images/tesla_model_y.png',
        lastBid: 28000.0,
        bidsCount: 12,
        status: VehicleStatus.active,
      ),
    ]);
    controller = SellController(mockRepo);
  });

  group('SellController Test Suite', () {
    test('Initializes and fetches vehicles successfully', () async {
      // Manually trigger onInit and verify loading state
      controller.onInit();
      expect(controller.isLoading.value, isTrue);
      
      // Wait for async fetch to complete
      await Future.delayed(const Duration(milliseconds: 25));
      
      expect(controller.isLoading.value, isFalse);
      expect(controller.listedVehicles.length, equals(2));
      expect(controller.listedVehicles.first.title, equals('2022 Ford F-150'));
    });

    test('Handles fetch errors gracefully', () async {
      mockRepo.shouldFail = true;
      
      // Manually trigger onInit which starts the fetch
      controller.onInit();
      
      // Wait for it to fail
      await Future.delayed(const Duration(milliseconds: 25));
      
      expect(controller.isLoading.value, isFalse);
      expect(controller.listedVehicles.length, equals(0)); // Should be 0 since it failed on initial fetch
    });

    test('Adds new listed vehicle successfully', () async {
      // Fetch initial items first
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 25));
      final initialCount = controller.listedVehicles.length;

      final addFuture = controller.addNewVehicle(
        '2021 Yamaha R1',
        11200.0,
        customImage: 'assets/images/yamaha_yzf_r1.png',
      );

      // Verify it sets loading state
      expect(controller.isLoading.value, isTrue);

      final success = await addFuture;

      expect(success, isTrue);
      expect(controller.isLoading.value, isFalse);
      expect(controller.listedVehicles.length, equals(initialCount + 1));
      
      final addedVehicle = controller.listedVehicles.last;
      expect(addedVehicle.title, equals('2021 Yamaha R1'));
      expect(addedVehicle.lastBid, equals(11200.0));
      expect(addedVehicle.status, equals(VehicleStatus.active));
      expect(addedVehicle.bidsCount, equals(0));
    });

    test('Handles error when adding new vehicle fails', () async {
      // Fetch initial items first
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 25));
      final initialCount = controller.listedVehicles.length;
      
      mockRepo.shouldFail = true;

      final success = await controller.addNewVehicle(
        '2024 Porsche 911',
        99000.0,
      );

      expect(success, isFalse);
      expect(controller.isLoading.value, isFalse);
      expect(controller.listedVehicles.length, equals(initialCount));
    });
  });
}
