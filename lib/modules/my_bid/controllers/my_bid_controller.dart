import 'package:get/get.dart';

enum MyBidTab { active, winning, outbid, won }

class BidItem {
  final String id;
  final String title;
  final String imagePath;
  final double userBid;
  final double currentBid;
  final int totalBids;
  final bool isWinning;
  final bool isWon;
  final bool isOutbid;

  const BidItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.userBid,
    required this.currentBid,
    required this.totalBids,
    this.isWinning = false,
    this.isWon = false,
    this.isOutbid = false,
  });
}

class MyBidController extends GetxController {
  final Rx<MyBidTab> selectedTab = MyBidTab.active.obs;

  final RxList<BidItem> allBids = <BidItem>[
    const BidItem(
      id: '1',
      title: '2022 Ford F-150 XLT',
      imagePath: 'assets/images/ford_f150.png',
      userBid: 18500.0,
      currentBid: 18500.0,
      totalBids: 43,
      isWinning: true,
    ),
    const BidItem(
      id: '2',
      title: '2023 Tesla Model Y',
      imagePath: 'assets/images/tesla_model_y.png',
      userBid: 28000.0,
      currentBid: 29500.0,
      totalBids: 65,
      isOutbid: true,
    ),
    const BidItem(
      id: '3',
      title: '2021 Yamaha YZF-R1',
      imagePath: 'assets/images/yamaha_yzf_r1.png',
      userBid: 11200.0,
      currentBid: 11200.0,
      totalBids: 22,
      isWon: true,
    ),
    const BidItem(
      id: '4',
      title: '2020 Chevrolet Camaro',
      imagePath: 'assets/images/onboarding_car.png',
      userBid: 22000.0,
      currentBid: 22000.0,
      totalBids: 18,
      isWinning: true,
    ),
    const BidItem(
      id: '5',
      title: '2022 Sea Ray SDX',
      imagePath: 'assets/images/sea_ray_sdx.png',
      userBid: 45000.0,
      currentBid: 45000.0,
      totalBids: 12,
      isWinning: true,
    ),
    const BidItem(
      id: '6',
      title: '2021 Ford Mustang',
      imagePath: 'assets/images/onboarding_car.png',
      userBid: 26000.0,
      currentBid: 27500.0,
      totalBids: 30,
      isOutbid: true,
    ),
    const BidItem(
      id: '7',
      title: '2022 Ducati Panigale',
      imagePath: 'assets/images/onboarding_motorcycle.png',
      userBid: 14000.0,
      currentBid: 15500.0,
      totalBids: 15,
      isOutbid: true,
    ),
    const BidItem(
      id: '8',
      title: '2019 Toyota Tacoma',
      imagePath: 'assets/images/onboarding_truck.png',
      userBid: 20000.0,
      currentBid: 20000.0,
      totalBids: 8,
      isWon: true,
    ),
    const BidItem(
      id: '9',
      title: '2023 BMW M4 Coupe',
      imagePath: 'assets/images/onboarding_car.png',
      userBid: 62000.0,
      currentBid: 62000.0,
      totalBids: 50,
      isWinning: true,
    ),
    const BidItem(
      id: '10',
      title: '2021 Dodge Ram 1500',
      imagePath: 'assets/images/onboarding_truck.png',
      userBid: 32500.0,
      currentBid: 32500.0,
      totalBids: 29,
      isWinning: true,
    ),
  ].obs;

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
    final index = allBids.indexWhere((b) => b.id == id);
    if (index != -1) {
      final oldBid = allBids[index];
      allBids[index] = BidItem(
        id: oldBid.id,
        title: oldBid.title,
        imagePath: oldBid.imagePath,
        userBid: newBidAmount,
        currentBid: newBidAmount,
        totalBids: oldBid.totalBids + 1,
        isWinning: true,
        isOutbid: false,
        isWon: false,
      );
    }
  }

  void changeTab(MyBidTab tab) {
    selectedTab.value = tab;
  }
}
