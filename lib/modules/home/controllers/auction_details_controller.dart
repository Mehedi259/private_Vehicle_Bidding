import 'dart:convert';
import 'package:get/get.dart';
import '../../../core/interfaces/i_auction_details_repository.dart';
import '../../../core/utils/api_error_parser.dart';
import '../../../data/models/auction_item.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class AuctionDetailsController extends GetxController {
  final IAuctionDetailsRepository _repository;
  final String itemId;

  AuctionDetailsController(this._repository, this.itemId);

  final Rx<AuctionItem?> auctionItem = Rx<AuctionItem?>(null);
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> comments = <Map<String, dynamic>>[].obs;
  final RxBool isCommentsLoading = false.obs;
  final RxInt selectedImageIndex = 0.obs;
  final Rx<LatLng?> mapLocation = Rx<LatLng?>(null);

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
      if (item != null) {
        _geocodeLocation(item);
      }
    } catch (e) {
      Get.log("Error loading auction details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _geocodeLocation(AuctionItem item) async {
    final addressParts = [item.country, item.state, item.city, item.zipCode]
        .where((e) => e.isNotEmpty)
        .toList();
    if (addressParts.isEmpty) return;

    final query = Uri.encodeComponent(addressParts.join(', '));
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    
    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'VehicleBiddingApp/1.0', // Required by Nominatim policy
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat']?.toString() ?? '');
          final lon = double.tryParse(data[0]['lon']?.toString() ?? '');
          if (lat != null && lon != null) {
            mapLocation.value = LatLng(lat, lon);
          }
        }
      }
    } catch (e) {
      Get.log('Geocoding failed: $e');
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
