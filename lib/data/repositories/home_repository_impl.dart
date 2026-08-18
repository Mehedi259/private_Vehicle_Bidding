import 'package:flutter/material.dart';
import '../../core/constants/custom_assets.dart';
import '../../core/interfaces/i_home_repository.dart';
import '../models/auction_item.dart';
import '../models/category_model.dart';
import 'dart:convert';
import '../../core/services/api_service.dart';

class HomeRepositoryImpl implements IHomeRepository {
  @override
  Future<List<AuctionItem>> getFeaturedAuctions() async {
    try {
      final response = await ApiService.get('/api/sell/posts/latest/');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AuctionItem.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch featured auctions: $e');
      return [];
    }
  }
  @override
  Future<List<AuctionItem>> getEndingSoonAuctions() async {
    try {
      final response = await ApiService.get('/api/sell/posts/ending-soon/');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AuctionItem.fromJson(json)).toList();
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
}
