import 'package:flutter/material.dart';
import '../../core/constants/custom_assets.dart';
import '../../core/interfaces/i_home_repository.dart';
import '../models/auction_item.dart';
import '../models/category_model.dart';
import 'dart:convert';
import '../../core/services/api_service.dart';

class HomeRepositoryImpl implements IHomeRepository {
  @override
  Future<List<AuctionItem>> getFeaturedAuctions({String? categoryId}) async {
    try {
      String endpoint = '/api/sell/posts/latest/';
      if (categoryId != null && categoryId != 'all') {
        final vehicleType = _mapCategoryIdToVehicleType(categoryId);
        endpoint = '/api/sell/posts/latest/?vehicle_type=$vehicleType';
      }
      final response = await ApiService.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<AuctionItem> items = data.map((json) => AuctionItem.fromJson(json)).toList();
        
        // Fallback local filtering because backend /latest/ endpoint currently ignores vehicle_type
        if (categoryId != null && categoryId != 'all') {
          final vehicleType = _mapCategoryIdToVehicleType(categoryId);
          items = items.where((item) => item.category.toLowerCase() == vehicleType.toLowerCase()).toList();
        }
        return items;
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch featured auctions: $e');
      return [];
    }
  }
  @override
  Future<List<AuctionItem>> getEndingSoonAuctions({String? categoryId}) async {
    try {
      String endpoint = '/api/sell/posts/ending-soon/';
      if (categoryId != null && categoryId != 'all') {
        final vehicleType = _mapCategoryIdToVehicleType(categoryId);
        endpoint = '/api/sell/posts/ending-soon/?vehicle_type=$vehicleType';
      }
      final response = await ApiService.get(endpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<AuctionItem> items = data.map((json) => AuctionItem.fromJson(json)).toList();
        
        // Fallback local filtering because backend /ending-soon/ endpoint currently ignores vehicle_type
        if (categoryId != null && categoryId != 'all') {
          final vehicleType = _mapCategoryIdToVehicleType(categoryId);
          items = items.where((item) => item.category.toLowerCase() == vehicleType.toLowerCase()).toList();
        }
        return items;
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch ending soon auctions: $e');
      return [];
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    return const [
      CategoryModel(id: 'cars', title: 'Cars', icon: Icons.directions_car_outlined),
      CategoryModel(id: 'bikes', title: 'Bikes', icon: Icons.motorcycle_outlined),
      CategoryModel(id: 'trucks', title: 'Trucks', icon: Icons.local_shipping_outlined),
      CategoryModel(id: 'boats', title: 'Boats', icon: Icons.directions_boat_outlined),
      CategoryModel(id: 'aircraft', title: 'Aircraft', icon: Icons.flight_outlined),
    ];
  }

  @override
  Future<bool> placeBid(String sellPostId, double amount) async {
    final response = await ApiService.post('/api/bids/', {
      'sell_post_id': sellPostId,
      'amount': amount,
    });
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(response.body); // Pass the raw response body so controller can parse it
    }
  }

  String _mapCategoryIdToVehicleType(String categoryId) {
    switch (categoryId) {
      case 'cars':
        return 'Car';
      case 'bikes':
        return 'Motorcycle';
      case 'trucks':
        return 'Truck';
      case 'boats':
        return 'Boat';
      case 'aircraft':
        return 'Aircraft';
      default:
        return 'Car';
    }
  }
}
