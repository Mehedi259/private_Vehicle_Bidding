import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_vehicle_bidding/core/interfaces/i_home_repository.dart';
import 'package:private_vehicle_bidding/data/models/auction_item.dart';
import 'package:private_vehicle_bidding/data/models/category_model.dart';
import 'package:private_vehicle_bidding/modules/home/controllers/home_controller.dart';

class MockHomeRepository implements IHomeRepository {
  final List<AuctionItem> auctions = [];
  final List<CategoryModel> categories = [];
  bool shouldFail = false;

  @override
  Future<List<AuctionItem>> getFeaturedAuctions() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      throw Exception('Repository error');
    }
    return auctions;
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 10));
    if (shouldFail) {
      throw Exception('Repository error');
    }
    return categories;
  }
}

void main() {
  late MockHomeRepository mockRepo;
  late HomeController controller;

  setUp(() {
    mockRepo = MockHomeRepository();
    mockRepo.categories.addAll([
      const CategoryModel(id: 'cars', title: 'Cars', icon: Icons.directions_car_outlined),
      const CategoryModel(id: 'bikes', title: 'Bikes', icon: Icons.motorcycle_outlined),
    ]);
    mockRepo.auctions.addAll([
      const AuctionItem(
        id: '1',
        title: '2022 Ford F-150',
        imageUrl: 'assets/images/ford_f150.png',
        currentBid: 18500.0,
        bidsCount: 5,
        category: 'trucks',
      ),
      const AuctionItem(
        id: '2',
        title: '2023 Tesla Model Y',
        imageUrl: 'assets/images/tesla_model_y.png',
        currentBid: 28000.0,
        bidsCount: 12,
        category: 'cars',
      ),
    ]);
    controller = HomeController(mockRepo);
  });

  group('HomeController Test Suite', () {
    test('Initializes with default states', () {
      expect(controller.selectedCategory.value, equals('all'));
      expect(controller.searchQuery.value, isEmpty);
      expect(controller.featuredAuctions, isEmpty);
      expect(controller.categories, isEmpty);
      expect(controller.isLoading.value, isFalse);
    });

    test('Fetches home data successfully', () async {
      controller.onInit();
      expect(controller.isLoading.value, isTrue);

      await Future.delayed(const Duration(milliseconds: 25));

      expect(controller.isLoading.value, isFalse);
      expect(controller.categories.length, equals(2));
      expect(controller.featuredAuctions.length, equals(2));
      expect(controller.notifications.length, equals(2));
    });

    test('Handles fetch errors gracefully', () async {
      mockRepo.shouldFail = true;
      controller.onInit();

      await Future.delayed(const Duration(milliseconds: 25));

      expect(controller.isLoading.value, isFalse);
      expect(controller.categories, isEmpty);
      expect(controller.featuredAuctions, isEmpty);
    });

    test('Select category toggles and updates selection', () {
      controller.selectCategory('cars');
      expect(controller.selectedCategory.value, equals('cars'));

      // Toggles back to 'all' if selected again
      controller.selectCategory('cars');
      expect(controller.selectedCategory.value, equals('all'));
    });

    test('Update search query works correctly', () {
      controller.updateSearchQuery('tesla');
      expect(controller.searchQuery.value, equals('tesla'));
    });

    test('Filtered auctions applies category and search query correctly', () async {
      // Fetch data first
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 25));

      // 1. Default (all)
      expect(controller.filteredAuctions.length, equals(2));

      // 2. Category filter
      controller.selectCategory('cars');
      expect(controller.filteredAuctions.length, equals(1));
      expect(controller.filteredAuctions.first.id, equals('2'));

      // 3. Search query filter
      controller.selectCategory('all');
      controller.updateSearchQuery('Ford');
      expect(controller.filteredAuctions.length, equals(1));
      expect(controller.filteredAuctions.first.id, equals('1'));

      // 4. Both category and search query filters
      controller.selectCategory('cars');
      controller.updateSearchQuery('Ford');
      expect(controller.filteredAuctions, isEmpty);
    });

    test('Place bid updates item details correctly', () async {
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 25));

      controller.placeBid('2', 29000.0);

      final updatedItem = controller.featuredAuctions.firstWhere((x) => x.id == '2');
      expect(updatedItem.currentBid, equals(29000.0));
      expect(updatedItem.bidsCount, equals(13));
      expect(updatedItem.recentBids.first.bidderName, equals('You'));
      expect(updatedItem.recentBids.first.amount, equals(29000.0));
    });
  });
}
