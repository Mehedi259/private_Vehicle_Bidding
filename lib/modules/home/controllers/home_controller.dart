import 'package:get/get.dart';
import '../../../core/interfaces/i_home_repository.dart';
import '../../../data/models/auction_item.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/notification_model.dart';

class HomeController extends GetxController {
  final IHomeRepository _homeRepository;

  HomeController(this._homeRepository);

  final RxList<AuctionItem> featuredAuctions = <AuctionItem>[].obs;
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

  void _loadNotifications() {
    notifications.assignAll([
      const NotificationModel(
        id: 'n1',
        title: '2023 Tesla Model Y',
        message: 'You are the highest bidder',
        vehicleId: '2',
        type: NotificationType.success,
        timeAgo: '',
      ),
      const NotificationModel(
        id: 'n2',
        title: '2021 Yamaha YZF-R1',
        message: 'Your bid has been surpassed',
        vehicleId: '4',
        type: NotificationType.surpassed,
        timeAgo: '',
      ),
    ]);
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      final auctionsData = await _homeRepository.getFeaturedAuctions();
      final categoriesData = await _homeRepository.getCategories();
      
      featuredAuctions.assignAll(auctionsData);
      categories.assignAll(categoriesData);
    } catch (e) {
      Get.log("Error loading home data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
