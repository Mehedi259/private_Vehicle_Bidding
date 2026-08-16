import 'dart:convert';
import 'package:get/get.dart';
import '../../../core/interfaces/i_home_repository.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/auction_item.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/notification_model.dart';

class HomeController extends GetxController {
  final IHomeRepository _homeRepository;

  HomeController(this._homeRepository);

  final RxList<AuctionItem> featuredAuctions = <AuctionItem>[].obs;
  final RxList<AuctionItem> endingSoonAuctions = <AuctionItem>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = false.obs;

  // ─── Filter & Search State ────────────────────────────────────────────────
  final RxString selectedCategory = 'all'.obs;
  final RxString searchQuery = ''.obs;

  List<AuctionItem> get filteredAuctions {
    return featuredAuctions.where((item) {
      final matchesCategory = selectedCategory.value == 'all' || item.category == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty || item.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  List<AuctionItem> get filteredEndingSoonAuctions {
    return endingSoonAuctions.where((item) {
      final matchesCategory = selectedCategory.value == 'all' || item.category == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty || item.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void selectCategory(String categoryId) {
    if (selectedCategory.value == categoryId) {
      selectedCategory.value = 'all';
    } else {
      selectedCategory.value = categoryId;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void placeBid(String itemId, double bidAmount) {
    final index = featuredAuctions.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final currentItem = featuredAuctions[index];
      final newBid = BidLog(
        bidderName: 'You',
        amount: bidAmount,
        timeAgo: 'Just now',
      );
      final updatedBids = [newBid, ...currentItem.recentBids];

      final updatedItem = currentItem.copyWith(
        currentBid: bidAmount,
        bidsCount: currentItem.bidsCount + 1,
        recentBids: updatedBids,
      );
      featuredAuctions[index] = updatedItem;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final response = await ApiService.get('/api/notifications/');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        notifications.assignAll(results.map((json) => NotificationModel.fromJson(json)).toList());
      }
    } catch (e) {
      Get.log("Error loading notifications: $e");
    }
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final futures = await Future.wait([
        _homeRepository.getFeaturedAuctions(),
        _homeRepository.getEndingSoonAuctions(),
        _homeRepository.getCategories(),
      ]);

      featuredAuctions.assignAll(futures[0] as List<AuctionItem>);
      endingSoonAuctions.assignAll(futures[1] as List<AuctionItem>);
      categories.assignAll(futures[2] as List<CategoryModel>);
    } catch (e) {
      Get.log("Error loading home data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
