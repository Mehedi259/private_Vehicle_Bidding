import 'dart:convert';
import 'package:get/get.dart';
import '../../core/constants/custom_assets.dart';
import '../../core/interfaces/i_sell_repository.dart';
import '../models/listed_vehicle.dart';
import '../../core/services/api_service.dart';

class SellRepositoryImpl implements ISellRepository {
  @override
  Future<List<ListedVehicle>> getListedVehicles() async {
    try {
      // 1. Get current user's profile to know their name
      final profileResponse = await ApiService.get('/accounts/user/profile/');
      if (profileResponse.statusCode != 200) return [];
      
      final profileData = jsonDecode(profileResponse.body);
      final String myName = profileData['name'] ?? '';

      if (myName.isEmpty) return [];

      // 2. Fetch all posts
      final response = await ApiService.get('/api/sell/posts/');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<ListedVehicle> myPosts = [];

        for (var json in data) {
          if (json['seller_name'] == myName) {
            String primaryImage = '';
            if (json['images'] != null && (json['images'] as List).isNotEmpty) {
              final images = json['images'] as List;
              final primary = images.firstWhere((img) => img['is_primary'] == true, orElse: () => images.first);
              primaryImage = primary['image'] ?? '';
            }

            VehicleStatus parsedStatus = VehicleStatus.active;
            if (json['status'] == 'sold' || json['auction_status'] == 'sold') {
              parsedStatus = VehicleStatus.sold;
            }

            myPosts.add(ListedVehicle(
              id: json['id'].toString(),
              title: '${json['year']} ${json['make']} ${json['model']}',
              imageUrl: primaryImage,
              lastBid: double.tryParse(json['current_highest_bid']?.toString() ?? '0') ?? 0.0,
              bidsCount: json['total_bids'] ?? 0,
              status: parsedStatus,
              buyNowPrice: double.tryParse(json['buy_now_price']?.toString() ?? ''),
            ));
          }
        }
        return myPosts;
      }
      return [];
    } catch (e) {
      Get.log('Failed to fetch listed vehicles: $e');
      return [];
    }
  }

  @override
  Future<ListedVehicle> addListedVehicle(ListedVehicle vehicle) async {
    // This is currently handled directly in the AddVehicleController
    // This method is just a placeholder if we ever need to add it via repository
    return vehicle;
  }
}
