import 'package:get/get.dart';
import '../../../core/interfaces/i_sell_repository.dart';
import '../../../data/models/listed_vehicle.dart';
import '../../../data/models/auction_item.dart';
import '../../home/controllers/home_controller.dart';

class SellController extends GetxController {
  final ISellRepository _sellRepository;

  SellController(this._sellRepository);

  final RxList<ListedVehicle> listedVehicles = <ListedVehicle>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchListedVehicles();
  }

  Future<void> fetchListedVehicles() async {
    isLoading.value = true;
    try {
      final data = await _sellRepository.getListedVehicles();
      listedVehicles.assignAll(data);
    } catch (e) {
      Get.log("Error loading listed vehicles: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addNewVehicle(String title, double startingBid, {String? customImage, double? buyNowPrice}) async {
    isLoading.value = true;
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final newVehicle = ListedVehicle(
        id: id,
        title: title,
        imageUrl: customImage ?? 'assets/images/ford_f150.png', // Fallback image if custom not specified
        lastBid: startingBid,
        bidsCount: 0,
        status: VehicleStatus.active,
        buyNowPrice: buyNowPrice,
      );

      final result = await _sellRepository.addListedVehicle(newVehicle);
      listedVehicles.add(result);

      // Sync with HomeController so details view can access it
      if (Get.isRegistered<HomeController>()) {
        final homeCtrl = Get.find<HomeController>();
        homeCtrl.featuredAuctions.add(
          AuctionItem(
            id: id,
            title: title,
            imageUrl: customImage ?? 'assets/images/ford_f150.png',
            currentBid: startingBid,
            bidsCount: 0,
            category: 'trucks',
            subtitle: 'Newly Listed',
            description: 'This vehicle was listed by you.',
            verifiedSeller: true,
            vinVerified: true,
            features: ['Clean Title', 'User Listed'],
            recentBids: [],
            buyNowPrice: buyNowPrice,
          ),
        );
      }

      return true;
    } catch (e) {
      Get.log("Error adding vehicle: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
