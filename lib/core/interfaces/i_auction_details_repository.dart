import '../../data/models/auction_item.dart';

abstract class IAuctionDetailsRepository {
  Future<AuctionItem?> getAuctionDetails(String id);
  Future<List<Map<String, dynamic>>> getComments(String sellPostId);
  Future<bool> postComment(String sellPostId, String text, {String? parentId});
}
