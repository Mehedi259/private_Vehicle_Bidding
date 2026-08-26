import re
import os

# 1. Fix FeaturedAuctionCard
file_path = "lib/modules/home/widgets/featured_auction_card.dart"
with open(file_path, "r") as f:
    content = f.read()

# Change width to double.infinity
content = re.sub(r'width: 176\.w,', 'width: double.infinity,', content)

# Wrap CountdownTimerWidget with Expanded
content = re.sub(r'CountdownTimerWidget\(endTime: item.endTime\),', 'Expanded(child: CountdownTimerWidget(endTime: item.endTime)),', content)

with open(file_path, "w") as f:
    f.write(content)


# 2. Fix home_view.dart
file_path = "lib/modules/home/views/home_view.dart"
with open(file_path, "r") as f:
    content = f.read()

# Replace the Row mapping logic for Featured Auctions
pattern1 = r'''return Row\(\s*mainAxisAlignment: MainAxisAlignment\.spaceBetween,\s*children: items\.map\(\(item\) \{\s*return FeaturedAuctionCard\(\s*item: item,\s*onTap: \(\) \{\s*context\.push\(AppRoutes\.auctionDetailsPath\(item\.id\)\);\s*\},\s*onPlaceBidTap: \(\) \{\s*PlaceBidDialog\.show\(context, item\)\.then\(\(bidAmount\) \{\s*if \(bidAmount != null\) \{\s*controller\.placeBid\(item\.id, bidAmount\);\s*\}\s*\}\);\s*\},\s*\);\s*\}\)\.toList\(\),\s*\);'''

replacement1 = '''return Row(
                      children: [
                        if (items.isNotEmpty)
                          Expanded(
                            child: FeaturedAuctionCard(
                              item: items[0],
                              onTap: () {
                                context.push(AppRoutes.auctionDetailsPath(items[0].id));
                              },
                              onPlaceBidTap: () {
                                PlaceBidDialog.show(context, items[0]).then((bidAmount) {
                                  if (bidAmount != null) {
                                    controller.placeBid(items[0].id, bidAmount);
                                  }
                                });
                              },
                            ),
                          ),
                        if (items.length > 1) SizedBox(width: 12.w),
                        if (items.length > 1)
                          Expanded(
                            child: FeaturedAuctionCard(
                              item: items[1],
                              onTap: () {
                                context.push(AppRoutes.auctionDetailsPath(items[1].id));
                              },
                              onPlaceBidTap: () {
                                PlaceBidDialog.show(context, items[1]).then((bidAmount) {
                                  if (bidAmount != null) {
                                    controller.placeBid(items[1].id, bidAmount);
                                  }
                                });
                              },
                            ),
                          ),
                      ],
                    );'''

# Because there are two such blocks (Featured Auctions and Ending Soon), we replace all
content = re.sub(pattern1, replacement1, content)

with open(file_path, "w") as f:
    f.write(content)


# 3. Fix GridViews in browse_view.dart and featured_auctions_view.dart
def fix_grid(file_path):
    with open(file_path, "r") as f:
        content = f.read()
    
    # Replace childAspectRatio with mainAxisExtent
    content = re.sub(r'childAspectRatio: 176 / 248,', 'mainAxisExtent: 260.h,', content)
    
    with open(file_path, "w") as f:
        f.write(content)

fix_grid("lib/modules/browse/views/browse_view.dart")
fix_grid("lib/modules/home/views/featured_auctions_view.dart")

print("Done")
