import 'dart:convert';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';

enum MyBidTab { active, winning, outbid, won }

class BidItem {
  final String id;
  final String title;
  final String imagePath;
  final double userBid;
  final double currentBid;
  final String bidStatus; // 'highest_bidder', 'outbid', 'won', 'lost'

  const BidItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.userBid,
    required this.currentBid,
    required this.bidStatus,
  });

  bool get isWinning => bidStatus == 'highest_bidder';
  bool get isWon => bidStatus == 'won';
  bool get isOutbid => bidStatus == 'outbid';
  bool get isLost => bidStatus == 'lost';
}

class MyBidController extends GetxController {
  final Rx<MyBidTab> selectedTab = MyBidTab.active.obs;

  final RxList<BidItem> allBids = <BidItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyBids();
  }

  Future<void> fetchMyBids() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('/api/bids/my-bids/');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> bidsData = data['bids'] ?? [];
        allBids.assignAll(bidsData.map((json) {
          final title = '${json['year']} ${json['make']} ${json['model']}';
          final myBid = double.tryParse(json['my_highest_bid']?.toString() ?? '0') ?? 0.0;
          final currentBid = double.tryParse(json['current_highest_bid']?.toString() ?? '0') ?? 0.0;
          return BidItem(
            id: json['sell_post_id'].toString(),
            title: title,
            imagePath: 'assets/images/ford_f150.png', // Since API doesn't return image right now, use fallback or update backend later
            userBid: myBid,
            currentBid: currentBid,
            bidStatus: json['bid_status'] ?? 'outbid',
          );
        }).toList());
      }
    } catch (e) {
      Get.log('Error fetching my bids: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<BidItem> get activeBids => allBids.where((b) => !b.isWon).toList();
  List<BidItem> get winningBids => allBids.where((b) => b.isWinning).toList();
  List<BidItem> get outbidBids => allBids.where((b) => b.isOutbid).toList();
  List<BidItem> get wonBids => allBids.where((b) => b.isWon).toList();

  List<BidItem> get currentTabItems {
    switch (selectedTab.value) {
      case MyBidTab.active:
        return activeBids;
      case MyBidTab.winning:
        return winningBids;
      case MyBidTab.outbid:
        return outbidBids;
      case MyBidTab.won:
        return wonBids;
    }
  }

  void updateBid(String id, double newBidAmount) {
    // Re-fetch bids from backend to get accurate state
    fetchMyBids();
  }

  void changeTab(MyBidTab tab) {
    selectedTab.value = tab;
  }
}
