import 'dart:convert';
import 'package:get/get.dart';
import '../../../core/interfaces/i_auction_details_repository.dart';
import '../../../core/utils/api_error_parser.dart';
import '../../../data/models/auction_item.dart';

class AuctionDetailsController extends GetxController {
  final IAuctionDetailsRepository _repository;
  final String itemId;

  AuctionDetailsController(this._repository, this.itemId);

  final Rx<AuctionItem?> auctionItem = Rx<AuctionItem?>(null);
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[].obs;
  final RxBool isCommentsLoading = false.obs;
  final RxInt selectedImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDetails();
    fetchComments();
  }

  Future<void> fetchDetails() async {
    isLoading.value = true;
    try {
      final item = await _repository.getAuctionDetails(itemId);
      auctionItem.value = item;
      selectedImageIndex.value = 0;
    } catch (e) {
      Get.log("Error loading auction details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComments() async {
    isCommentsLoading.value = true;
    try {
      final data = await _repository.getComments(itemId);
      comments.assignAll(data);
    } catch (e) {
      Get.log("Error loading comments: $e");
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<bool> postComment(String text, {String? parentId}) async {
    final success = await _repository.postComment(itemId, text, parentId: parentId);
    if (success) {
      await fetchComments();
    }
    return success;
  }

  Future<String?> placeBid(double amount) async {
    try {
      await _repository.placeBid(itemId, amount);
      await fetchDetails(); // Refresh details to show new bid
      return null; // Success
    } catch (e) {
      return ApiErrorParser.parse(e, defaultMessage: 'Failed to place bid. Please try again.');
    }
  }
}
