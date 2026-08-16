import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/interfaces/i_home_repository.dart';
import '../../../data/repositories/home_repository_impl.dart';
import '../../../shared/widgets/place_bid_dialog.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/category_model.dart';
import '../../../shared/widgets/category_card.dart';
import '../widgets/featured_auction_card.dart';
import '../widgets/home_banner.dart';
import '../widgets/home_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    // Register dependencies if they are not already active
    if (!Get.isRegistered<IHomeRepository>()) {
      Get.lazyPut<IHomeRepository>(() => HomeRepositoryImpl());
    }
    controller = Get.put(HomeController(Get.find<IHomeRepository>()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1B4E9F),
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Logo & Notification bell)
                const HomeHeader(),
                SizedBox(height: 20.h),

                // 2. Welcome Greeting
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Frank',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Find your next vehicle',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // 3. Main Promo Banner
                const HomeBanner(),
                SizedBox(height: 24.h),

                // 4. Categories Section
                Text(
                  'Categories',
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF2A2A2A),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: CategoryCard(
                          category: CategoryModel(
                            id: 'all',
                            title: 'All',
                            icon: Icons.grid_view_rounded,
                          ),
                          isSelected: controller.selectedCategory.value == 'all',
                          onTap: () => controller.selectCategory('all'),
                        ),
                      ),
                      ...controller.categories.map((category) {
                        final isSelected = controller.selectedCategory.value == category.id;
                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: CategoryCard(
                            category: category,
                            isSelected: isSelected,
                            onTap: () => controller.selectCategory(category.id),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Featured Auctions',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.featuredAuctions),
                      child: Text(
                        'View all',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF1B4E9F),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // 6. Featured Auctions Cards
                Builder(
                  builder: (context) {
                    final items = controller.filteredAuctions.take(2).toList();
                    if (items.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        alignment: Alignment.center,
                        child: Text(
                          'No featured auctions found in this category.',
                          style: GoogleFonts.outfit(
                            color: const Color(0x992A2A2A),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: items.map((item) {
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
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // 7. Ending Soon Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Ending Soon',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.featuredAuctions), // Can be updated to ending soon route
                      child: Text(
                        'View all',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF1B4E9F),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // 8. Ending Soon Cards
                Builder(
                  builder: (context) {
                    final items = controller.filteredEndingSoonAuctions.take(2).toList();
                    if (items.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        alignment: Alignment.center,
                        child: Text(
                          'No ending soon auctions found.',
                          style: GoogleFonts.outfit(
                            color: const Color(0x992A2A2A),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: items.map((item) {
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
                      }).toList(),
                    );
                  },
                ),

                // Spacing at the bottom to prevent navbar overlapping
                SizedBox(height: 100.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
