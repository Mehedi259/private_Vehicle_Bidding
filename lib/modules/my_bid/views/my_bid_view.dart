import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/interfaces/i_home_repository.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/repositories/home_repository_impl.dart';
import '../../../shared/widgets/place_bid_dialog.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/my_bid_controller.dart';
import '../../../core/services/api_service.dart';
import 'package:intl/intl.dart';

class MyBidView extends StatelessWidget {
  const MyBidView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyBidController>(
      init: MyBidController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Title and Subtitle)
                Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 24.h, right: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Bids',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Track your auctions and bids',
                        style: GoogleFonts.outfit(
                          color: const Color(0xB22A2A2A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // 2. Horizontal Scrollable Tabs Selection
                _buildTabsRow(controller),
                SizedBox(height: 16.h),

                // 3. Grid of Bid Cards
                Expanded(
                  child: Obx(() {
                    final items = controller.currentTabItems;

                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'No bids in this section.',
                          style: GoogleFonts.outfit(
                            color: const Color(0x992A2A2A),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 176 / 262,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildBidCard(context, controller, items[index]);
                      },
                    );
                  }),
                ),
                SizedBox(height: 90.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabsRow(MyBidController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() {
        final activeTab = controller.selectedTab.value;

        return Row(
          children: [
            _buildTabButton(
              label: 'Active Bids',
              isSelected: activeTab == MyBidTab.active,
              onTap: () => controller.changeTab(MyBidTab.active),
            ),
            _buildTabButton(
              label: 'Winning',
              countText: ' (${controller.winningBids.length})',
              countColor: const Color(0xFF05BE27),
              isSelected: activeTab == MyBidTab.winning,
              onTap: () => controller.changeTab(MyBidTab.winning),
            ),
            _buildTabButton(
              label: 'Outbid',
              countText: ' (${controller.outbidBids.length})',
              countColor: const Color(0xFFF86247),
              isSelected: activeTab == MyBidTab.outbid,
              onTap: () => controller.changeTab(MyBidTab.outbid),
            ),
            _buildTabButton(
              label: 'Won',
              countText: ' (${controller.wonBids.length})',
              countColor: const Color(0xFF05BE27),
              isSelected: activeTab == MyBidTab.won,
              onTap: () => controller.changeTab(MyBidTab.won),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabButton({
    required String label,
    String? countText,
    Color? countColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEFF5FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: isSelected ? const Color(0xFF1B4E9F) : Colors.black.withOpacity(0.08),
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFF2A2A2A),
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (countText != null)
              Text(
                countText,
                style: GoogleFonts.outfit(
                  color: isSelected ? const Color(0xFF1B4E9F) : (countColor ?? const Color(0xFF05BE27)),
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBidCard(BuildContext context, MyBidController controller, BidItem item) {
    String label = 'Your Bid';
    Color priceColor = const Color(0xFF05BE28);
    String badgeText = 'Highest Bidder';
    Color badgeColor = const Color(0xFF05BE28);
    String buttonText = 'View Auction';
    bool isOutlined = false;
    Color buttonColor = const Color(0xFF1B4E9F);
    Color buttonTextColor = Colors.white;

    if (item.isOutbid) {
      priceColor = const Color(0xFFF86247);
      badgeText = 'Outbid';
      badgeColor = const Color(0xFFF86247);
      buttonText = 'Bid Again';
      isOutlined = true;
      buttonColor = const Color(0xFF1B4E9F);
      buttonTextColor = const Color(0xFF1B4E9F);
    } else if (item.isWon) {
      label = 'Current Bid';
      priceColor = const Color(0xFF05BE28);
      badgeText = 'Won';
      badgeColor = const Color(0xFF05BE28);
      buttonText = 'View Payment';
      isOutlined = true;
      buttonColor = const Color(0xFF05BE28);
      buttonTextColor = const Color(0xFF05BE28);
    }

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: Colors.black.withOpacity(0.08),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Vehicle image
          Container(
            height: 96.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
              child: item.imagePath.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: item.imagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: const Color(0xFF1B4E9F),
                            size: 24.r,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  : (item.imagePath.startsWith('/') || item.imagePath.contains(':'))
                      ? Image.file(
                          File(item.imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          item.imagePath,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
          
          // 2. Details body
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF2A2A2A),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.outfit(
                          color: const Color(0x992A2A2A),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '\$${item.userBid.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: GoogleFonts.outfit(
                                color: priceColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: const Color(0xFF1B4E9F),
                                size: 12.sp,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Ends soon',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF1B4E9F),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // View Button
                  GestureDetector(
                    onTap: () {
                      if (item.isWon) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            title: Row(
                              children: [
                                Icon(Icons.payment_rounded, color: const Color(0xFF05BE28), size: 24.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  'Secure Checkout',
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF2A2A2A),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You are paying for:',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  item.title,
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF2A2A2A),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Winning Bid Amount:',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '\$${item.userBid.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF05BE28),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Buyer Premium (5%):',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF6B7280),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '\$${(item.userBid * 0.05).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF2A2A2A),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.black.withOpacity(0.06), height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Amount Due:',
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF2A2A2A),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '\$${(item.userBid * 1.05).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                      style: GoogleFonts.outfit(
                                        color: const Color(0xFF1B4E9F),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'Cancel',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  SnackbarHelper.showSuccess('Payment processed successfully! Release document is ready.');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF05BE28),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                                ),
                                child: Text(
                                  'Pay Now',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (item.isOutbid) {
                        if (!Get.isRegistered<HomeController>()) {
                          if (!Get.isRegistered<IHomeRepository>()) {
                            Get.lazyPut<IHomeRepository>(() => HomeRepositoryImpl());
                          }
                          Get.put(HomeController(Get.find<IHomeRepository>()));
                        }
                        final homeController = Get.find<HomeController>();
                        final auctionItem = homeController.featuredAuctions.firstWhereOrNull((a) => a.id == item.id) ?? 
                                            homeController.endingSoonAuctions.firstWhereOrNull((a) => a.id == item.id);
                        if (auctionItem != null) {
                          PlaceBidDialog.show(context, auctionItem).then((newBidAmount) async {
                            if (newBidAmount != null) {
                              try {
                                final response = await ApiService.post('/api/bids/', {
                                  'sell_post_id': item.id,
                                  'amount': newBidAmount,
                                });
                                if (response.statusCode == 201) {
                                  final currencyFormat = NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0);
                                  SnackbarHelper.showSuccess('Bid of ${currencyFormat.format(newBidAmount)} placed successfully!');
                                  controller.updateBid(item.id, newBidAmount);
                                } else {
                                  SnackbarHelper.showError('Failed to place bid.');
                                }
                              } catch (e) {
                                SnackbarHelper.showError('Failed to place bid.');
                              }
                            }
                          });
                        } else {
                          SnackbarHelper.showError('Auction item details not found in home feed.');
                        }
                      } else {
                        context.push(AppRoutes.auctionDetailsPath(item.id));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 28.h,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: isOutlined ? Colors.white : buttonColor,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1.w,
                            color: buttonColor,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.poppins(
                          color: buttonTextColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
