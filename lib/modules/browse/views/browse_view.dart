import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_routes.dart';
import '../../../data/models/category_model.dart';
import '../../../shared/widgets/place_bid_dialog.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../shared/widgets/category_card.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/widgets/featured_auction_card.dart';

class BrowseView extends StatefulWidget {
  const BrowseView({super.key});

  @override
  State<BrowseView> createState() => _BrowseViewState();
}

class _BrowseViewState extends State<BrowseView> {
  late final HomeController controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    // Synchronize text field with search query state
    _searchController.text = controller.searchQuery.value;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Section (Title, Subtitle, and Bell)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Browse Vehicles',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF2A2A2A),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Find your next vehicle in our trusted auctions',
                          style: GoogleFonts.outfit(
                            color: const Color(0xB22A2A2A),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRoutes.notifications);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: const Color(0xFF1B4E9F),
                        size: 24.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // Main Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: 110.h), // space for bottom navbar cutout
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: AppSearchBar(
                        controller: _searchController,
                        onChanged: controller.updateSearchQuery,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // 3. Category Horizontal Filter List
                    Obx(() => _buildCategories()),
                    SizedBox(height: 24.h),

                    // 4. Auctions Header Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Auctions',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // 5. Auctions 2-Column Grid
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Obx(() {
                        final items = controller.filteredAuctions;
                        if (items.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Text(
                                'No auctions found.',
                                style: GoogleFonts.outfit(
                                  color: const Color(0x992A2A2A),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 16.h,
                            childAspectRatio: 176 / 248,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return FeaturedAuctionCard(
                              item: item,
                              onTap: () {
                                context.push(AppRoutes.auctionDetailsPath(item.id));
                              },
                              onPlaceBidTap: () {
                                PlaceBidDialog.show(context, item).then((bidAmount) {
                                  if (bidAmount != null) {
                                    controller.placeBid(item.id, bidAmount);
                                  }
                                });
                              },
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    const allCategory = CategoryModel(
      id: 'all',
      title: 'All',
      icon: Icons.grid_view_rounded,
    );

    final list = [allCategory, ...controller.categories];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: list.map((cat) {
          final isSelected = controller.selectedCategory.value == cat.id;

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CategoryCard(
              category: cat,
              isSelected: isSelected,
              onTap: () => controller.selectCategory(cat.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}
