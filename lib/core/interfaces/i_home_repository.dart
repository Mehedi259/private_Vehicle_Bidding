import '../../data/models/auction_item.dart';
import '../../data/models/category_model.dart';

abstract class IHomeRepository {
  Future<List<AuctionItem>> getFeaturedAuctions();
  Future<List<AuctionItem>> getEndingSoonAuctions();
  Future<List<CategoryModel>> getCategories();
  Future<bool> placeBid(String sellPostId, double amount);
}
