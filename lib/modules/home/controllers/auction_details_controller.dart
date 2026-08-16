import 'package:get/get.dart';
import '../../../core/interfaces/i_auction_details_repository.dart';
import '../../../data/models/auction_item.dart';

class AuctionDetailsController extends GetxController {
  final IAuctionDetailsRepository _repository;
  final String itemId;

  AuctionDetailsController(this._repository, this.itemId);

  final Rx<AuctionItem?> auctionItem = Rx<AuctionItem?>(null);
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[].obs;
  final RxBool isCommentsLoading = false.obs;

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
}
