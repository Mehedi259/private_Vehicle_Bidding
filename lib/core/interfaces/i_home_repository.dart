import '../../data/models/auction_item.dart';
import '../../data/models/category_model.dart';

abstract class IHomeRepository {
  Future<List<AuctionItem>> getFeaturedAuctions({String? categoryId});
  Future<List<AuctionItem>> getEndingSoonAuctions({String? categoryId});
  Future<List<CategoryModel>> getCategories();
  Future<bool> placeBid(String sellPostId, double amount);
}
