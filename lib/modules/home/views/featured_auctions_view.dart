import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_routes.dart';
import '../../../data/models/category_model.dart';
import '../../../shared/widgets/place_bid_dialog.dart';
import '../controllers/home_controller.dart';
import '../widgets/featured_auction_card.dart';
import '../../../shared/widgets/app_back_button.dart';

class FeaturedAuctionsView extends StatefulWidget {
  const FeaturedAuctionsView({super.key});

  @override
  State<FeaturedAuctionsView> createState() => _FeaturedAuctionsViewState();
}

class _FeaturedAuctionsViewState extends State<FeaturedAuctionsView> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom Header Row with Back Button, Centered Title & Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  AppBackButton(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Featured Auctions',
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
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 34.w), // Balanced spacing spacer
                ],
              ),
            ),

            // Main Scrollable Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Search Bar
                    Container(
                      height: 46.h,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF9FAFB),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.w,
                            color: const Color(0x33454545),
                          ),
                          borderRadius: BorderRadius.circular(43.r),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x28ACB5DA),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: TextField(
                        onChanged: controller.updateSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Search make, model, type...',
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0x7F323232),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: const Color(0x7F323232),
                            size: 20.sp,
                          ),
                          suffixIcon: Icon(
                            Icons.tune_rounded,
                            color: const Color(0xFF1B4E9F),
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // 3. Category Horizontal Filter List
                    Obx(() => _buildCategories(controller)),
                    SizedBox(height: 28.h),

                    // 4. Auctions Title
                    Text(
                      'Auctions',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // 5. Featured Auctions Responsive Grid
                    Obx(() {
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
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(HomeController controller) {
    const allCategory = CategoryModel(
      id: 'all',
      title: 'All',
      icon: Icons.grid_view_rounded,
    );

    final list = [allCategory, ...controller.categories];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: list.map((cat) {
          final isSelected = controller.selectedCategory.value == cat.id;
          return GestureDetector(
            onTap: () => controller.selectCategory(cat.id),
            child: Container(
              width: cat.id == 'all' ? 56.w : 64.w,
              height: 67.h,
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
         
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    cat.icon,
                    color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xCC2A2A2A),
                    size: 28.sp,
                  ),
                  SizedBox(height: 2.h),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      cat.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xCC2A2A2A),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
