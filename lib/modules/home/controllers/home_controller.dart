import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/interfaces/i_home_repository.dart';
import '../../../core/services/api_service.dart';
import '../../../data/models/auction_item.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/notification_model.dart';
import '../../../core/utils/snackbar_helper.dart';

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
      final matchesSearch = searchQuery.value.isEmpty || item.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  List<AuctionItem> get filteredEndingSoonAuctions {
    return endingSoonAuctions.where((item) {
      final matchesSearch = searchQuery.value.isEmpty || item.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  Future<void> selectCategory(String categoryId) async {
    if (selectedCategory.value == categoryId) {
      selectedCategory.value = 'all';
    } else {
      selectedCategory.value = categoryId;
    }
    
    // Fetch auctions with the new category
    isLoading.value = true;
    try {
      final futures = await Future.wait([
        _homeRepository.getFeaturedAuctions(categoryId: selectedCategory.value),
        _homeRepository.getEndingSoonAuctions(categoryId: selectedCategory.value),
      ]);
      featuredAuctions.assignAll(futures[0]);
      endingSoonAuctions.assignAll(futures[1]);
    } catch (e) {
      Get.log("Error filtering by category: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future<void> placeBid(String itemId, double bidAmount, {BuildContext? context}) async {
    try {
      final success = await _homeRepository.placeBid(itemId, bidAmount);
      if (!success) {
        SnackbarHelper.showError('Failed to place bid. Please try again.');
        return;
      }
      
      SnackbarHelper.showSuccess('Bid placed successfully!');
  
      // Update local state optimistically
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
      
      // Also update endingSoonAuctions if it's there
      final endingIndex = endingSoonAuctions.indexWhere((item) => item.id == itemId);
      if (endingIndex != -1) {
        final currentItem = endingSoonAuctions[endingIndex];
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
        endingSoonAuctions[endingIndex] = updatedItem;
      }
    } catch (e) {
      final errorMsg = e.toString();
      if (errorMsg.contains('payment')) {
        // Show dialog to navigate to payment methods
        if (context != null && context.mounted) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: 'Payment Method Required',
            desc: 'A valid payment card is required to place a bid. Please add your card details first.',
            btnCancelOnPress: () {},
            btnOkText: 'Add Card',
            btnOkOnPress: () {
              context.push(AppRoutes.paymentMethods);
            },
          ).show();
        } else {
          SnackbarHelper.showError('A valid payment card is required to place a bid. Please go to Profile > Payment Methods to add one.');
        }
      } else {
        SnackbarHelper.showError('Failed to place bid. Please try again.');
      }
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
        List<dynamic> results = [];
        if (data is List) {
          results = data;
        } else if (data is Map<String, dynamic> && data['results'] != null) {
          results = data['results'];
        }
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
        _homeRepository.getFeaturedAuctions(categoryId: selectedCategory.value),
        _homeRepository.getEndingSoonAuctions(categoryId: selectedCategory.value),
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
