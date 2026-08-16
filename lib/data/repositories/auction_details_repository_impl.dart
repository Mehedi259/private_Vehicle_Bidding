import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/interfaces/i_auction_details_repository.dart';
import '../../core/services/api_service.dart';
import '../models/auction_item.dart';

class AuctionDetailsRepositoryImpl implements IAuctionDetailsRepository {
  @override
  Future<AuctionItem?> getAuctionDetails(String id) async {
    try {
      final response = await ApiService.get('/api/sell/posts/$id/', requireAuth: false);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AuctionItem.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Failed to fetch auction details: $e');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getComments(String sellPostId) async {
    try {
      final response = await ApiService.get('/api/sell/comments/?sell_post_id=$sellPostId', requireAuth: false);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch comments: $e');
      return [];
    }
  }

  @override
  Future<bool> postComment(String sellPostId, String text, {String? parentId}) async {
    try {
      final body = {
        'sell_post': sellPostId,
        'text': text,
      };
      if (parentId != null) {
        body['parent'] = parentId;
      }
      final response = await ApiService.post('/api/sell/comments/', body: body);
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Failed to post comment: $e');
      return false;
    }
  }

  @override
  Future<bool> placeBid(String sellPostId, double amount) async {
    try {
      final response = await ApiService.post('/api/bids/', {
        'sell_post': sellPostId,
        'amount': amount,
      });
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Failed to place bid: $e');
      return false;
    }
  }
}
