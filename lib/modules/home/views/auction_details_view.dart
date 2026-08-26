import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/utils/snackbar_helper.dart';
import '../../../shared/widgets/place_bid_dialog.dart';
import '../../../core/interfaces/i_auction_details_repository.dart';
import '../../../data/repositories/auction_details_repository_impl.dart';
import '../controllers/auction_details_controller.dart';
import '../../../data/models/auction_item.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/countdown_timer_widget.dart';

class AuctionDetailsView extends StatefulWidget {
  final String itemId;

  const AuctionDetailsView({super.key, required this.itemId});

  @override
  State<AuctionDetailsView> createState() => _AuctionDetailsViewState();
}

class _AuctionDetailsViewState extends State<AuctionDetailsView> {
  late final AuctionDetailsController controller;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<IAuctionDetailsRepository>()) {
      Get.lazyPut<IAuctionDetailsRepository>(() => AuctionDetailsRepositoryImpl());
    }
    controller = Get.put(
      AuctionDetailsController(Get.find<IAuctionDetailsRepository>(), widget.itemId),
      tag: widget.itemId,
    );
  }

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _formatTimeAgo(String? timestamp) {
    if (timestamp == null || timestamp.isEmpty) return 'Just now';
    try {
      final DateTime time = DateTime.parse(timestamp);
      final Duration diff = DateTime.now().difference(time);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final item = controller.auctionItem.value;
        final selectedIndex = controller.selectedImageIndex.value;

        if (item == null) {
          return const Scaffold(
            body: Center(
              child: Text('Auction item not found.'),
            ),
          );
        }

        return Stack(
          children: [
            // Scrollable Content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Vehicle Photo & Top Controls Overlay
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 269.h,
                          child: Builder(
                            builder: (context) {
                              final currentMainImage = (item.images.isNotEmpty && selectedIndex < item.images.length)
                                  ? item.images[selectedIndex]
                                  : item.imageUrl;
                              
                              return currentMainImage.startsWith('http')
                                  ? CachedNetworkImage(
                                      imageUrl: currentMainImage,
                                      fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: LoadingAnimationWidget.threeArchedCircle(
                                        color: const Color(0xFF1B4E9F),
                                        size: 32.r,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image, size: 40),
                                  ),
                                )
                              : (currentMainImage.startsWith('/') || currentMainImage.contains(':'))
                                  ? Image.file(
                                      File(currentMainImage),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Image.asset(
                                        currentMainImage,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      currentMainImage,
                                      fit: BoxFit.cover,
                                    );
                            },
                          ),
                        ),
                        // Safe Area Back Button
                        Positioned(
                          left: 16.w,
                          top: MediaQuery.of(context).padding.top + 10.h,
                          child: const AppBackButton(),
                        ),
                        // Photos Counter Overlay
                        Positioned(
                          bottom: 12.h,
                          left: 0,
                          right: 0,
                          child: Text(
                            '${selectedIndex + 1}/${item.images.isNotEmpty ? item.images.length : 1} Photos',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // 2. Gallery Thumbnails List
                    SizedBox(
                      height: 46.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: item.images.isNotEmpty ? item.images.length : 1,
                        itemBuilder: (context, index) {
                          final currentImageUrl = item.images.isNotEmpty ? item.images[index] : item.imageUrl;
                          final isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              controller.selectedImageIndex.value = index;
                            },
                            child: Container(
                              width: 44.w,
                              height: 44.h,
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  side: isSelected
                                      ? BorderSide(color: const Color(0xFF1B4E9F), width: 2.w)
                                      : BorderSide.none,
                                ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: currentImageUrl.startsWith('http')
                                  ? CachedNetworkImage(
                                      imageUrl: currentImageUrl,
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            alignment: Alignment(
                                              (index - 3) * 0.3,
                                              0.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: LoadingAnimationWidget.threeArchedCircle(
                                            color: const Color(0xFF1B4E9F),
                                            size: 12.r,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image, size: 16),
                                      ),
                                    )
                                  : (currentImageUrl.startsWith('/') || currentImageUrl.contains(':'))
                                      ? Image.file(
                                          File(currentImageUrl),
                                          fit: BoxFit.cover,
                                          alignment: Alignment(
                                            (index - 3) * 0.3,
                                            0.0,
                                          ),
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            currentImageUrl,
                                            fit: BoxFit.cover,
                                            alignment: Alignment(
                                              (index - 3) * 0.3,
                                              0.0,
                                            ),
                                          ),
                                        )
                                      : Image.asset(
                                          currentImageUrl,
                                          fit: BoxFit.cover,
                                          alignment: Alignment(
                                            (index - 3) * 0.3,
                                            0.0,
                                          ),
                                        ),
                            ),
                          ),
                        );
                      },
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Main Details Wrapper
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 3. Bid Status Card
                          _buildBidStatusCard(context, item, currencyFormat, controller),
                          SizedBox(height: 24.h),

                          // 4. Vehicle Title Section
                          Text(
                            'Vehicle Title',
                            style: GoogleFonts.outfit(
                              color: const Color(0x992A2A2A),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            item.title,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF2A2A2A),
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (item.subtitle.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              item.subtitle,
                              style: GoogleFonts.outfit(
                                color: const Color(0xCC2A2A2A),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                          SizedBox(height: 12.h),

                          // Verified Badges Row
                          Row(
                            children: [
                              if (item.verifiedSeller)
                                _buildBadge('Verified Seller', Icons.verified_user_rounded),
                              if (item.vinVerified) ...[
                                SizedBox(width: 8.w),
                                _buildBadge('Vin Verified', Icons.check_circle_rounded),
                              ],
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // 5. Quick Specs Row
                          Text(
                            'Quick Specs',
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
                              Expanded(
                                child: _buildSpecCard(
                                  'Mileage',
                                  item.mileage,
                                  Icons.speed_rounded,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _buildSpecCard(
                                  'Transmission',
                                  item.transmission,
                                  Icons.settings_input_component_rounded,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: _buildSpecCard(
                                  'Fuel Type',
                                  item.fuelType,
                                  Icons.local_gas_station_rounded,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // 6. Bid Activity Section
                          _buildBidActivitySection(item, currencyFormat),
                          SizedBox(height: 24.h),

                          // 7. Vehicle Description Card
                          _buildDescriptionSection(item),
                          SizedBox(height: 24.h),

                          // 8. Features Checklist Card
                          _buildFeaturesSection(item),
                          SizedBox(height: 24.h),

                          // 9. Independent Inspection Card
                          _buildInspectionSection(context),
                          SizedBox(height: 24.h),

                          // 10. Location Card
                          _buildLocationSection(item),
                          SizedBox(height: 24.h),

                          // 11. Comments Section
                          _buildCommentsSection(),

                          // Spacing at the bottom to avoid sticky bar overlapping
                          SizedBox(height: 120.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 11. Sticky Bottom Action Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildStickyBottomBar(context, item, currencyFormat, controller),
            ),
           //  SizedBox(height: 12.h),
          ],
          
        );
      }),
    );
  }

  // Bid Status Card widget
  Widget _buildBidStatusCard(
    BuildContext context,
    AuctionItem item,
    NumberFormat currencyFormat,
    AuctionDetailsController controller,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2.w,
            color: const Color(0xFF1B4E9F),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Current Bid',
            style: GoogleFonts.outfit(
              color: const Color(0xFF2A2A2A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            currencyFormat.format(item.currentBid),
            style: GoogleFonts.outfit(
              color: const Color(0xFF1B4E9F),
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFF1B4E9F),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gavel_rounded,
                color: const Color(0xFF2A2A2A),
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                '${item.bidsCount} Bids',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer_outlined,
                color: const Color(0xFFF86247),
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              CountdownTimerWidget(endTime: item.endTime),
            ],
          ),
          SizedBox(height: 12.h),
          // Place Bid inside card
          GestureDetector(
            onTap: () {
              PlaceBidDialog.show(context, item).then((bidAmount) async {
                if (bidAmount != null) {
                  final errorMsg = await controller.placeBid(bidAmount);
                  if (errorMsg == null) {
                    final currencyFormat = NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0);
                    SnackbarHelper.showSuccess('Bid of ${currencyFormat.format(bidAmount)} placed successfully!');
                  } else {
                    SnackbarHelper.showError(errorMsg);
                  }
                }
              });
            },
            child: Container(
              width: double.infinity,
              height: 38.h,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: const Color(0xFF1B4E9F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Place Bid',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Verification Badge builder
  Widget _buildBadge(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: ShapeDecoration(
        color: const Color(0xFF05BE28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // Spec card builder
  Widget _buildSpecCard(String label, String value, IconData icon) {
    return Container(
      height: 77.h,
      padding: EdgeInsets.all(6.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: Colors.black.withValues(alpha: 0.10),
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1B4E9F),
            size: 18.sp,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: const Color(0xCC2A2A2A),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value.isNotEmpty ? value : 'N/A',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: const Color(0xFF2A2A2A),
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bid Activity list builder
  Widget _buildBidActivitySection(AuctionItem item, NumberFormat currencyFormat) {
    final uniqueBidders = item.recentBids.map((b) => b.bidderName).toSet().toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: const Color(0x222A2A2A),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bid Activity (${uniqueBidders.length} Bidders)',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {},
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
          if (uniqueBidders.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: uniqueBidders.map((name) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.05),
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16.r,
                        height: 16.r,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1B4E9F),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'B',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          SizedBox(height: 12.h),
          if (item.recentBids.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                'No activity yet.',
                style: GoogleFonts.outfit(
                  color: const Color(0xCC2A2A2A),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.recentBids.length,
              separatorBuilder: (context, index) => SizedBox(height: 8.h),
              itemBuilder: (context, index) {
                final bid = item.recentBids[index];
                final isTop = index == 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        bid.bidderName,
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF2A2A2A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        currencyFormat.format(bid.amount),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: isTop ? const Color(0xFFF86247) : const Color(0xFF2A2A2A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        bid.timeAgo,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.outfit(
                          color: const Color(0xB22A2A2A),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  // Description card builder
  Widget _buildDescriptionSection(AuctionItem item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: const Color(0x222A2A2A),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vehicle Description',
            style: GoogleFonts.outfit(
              color: const Color(0xFF2A2A2A),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            item.description.isNotEmpty
                ? item.description
                : 'No description provided.',
            style: GoogleFonts.outfit(
              color: const Color(0xCC2A2A2A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Features checklist builder
  Widget _buildFeaturesSection(AuctionItem item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: const Color(0x222A2A2A),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: GoogleFonts.outfit(
              color: const Color(0xFF2A2A2A),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          if (item.features.isEmpty)
            Text(
              'No features listed.',
              style: GoogleFonts.outfit(
                color: const Color(0xCC2A2A2A),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          else
            Wrap(
              spacing: 16.w,
              runSpacing: 12.h,
              children: item.features.map((feature) {
                return FractionallySizedBox(
                  widthFactor: 0.47, // slightly less than half to fit two items with spacing
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h), // align icon with first line of text
                        child: Icon(
                          Icons.check_rounded,
                          color: const Color(0xFF1B4E9F),
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF1B4E9F),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  // Independent Inspection Card builder
  Widget _buildInspectionSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: const Color(0xFFFDF2D3),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            color: const Color(0x222A2A2A),
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Independent Inspection:',
            style: GoogleFonts.outfit(
              color: const Color(0xFF2A2A2A),
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Get Vehicle inspected before purchase',
            style: GoogleFonts.outfit(
              color: const Color(0xCC2A2A2A),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () {
              SnackbarHelper.showSuccess('Inspection request submitted successfully!');
            },
            child: Container(
              width: double.infinity,
              height: 38.h,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: const Color(0xFFFAC249),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Text(
                'Request Inspection',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Location Section Builder
  Widget _buildLocationSection(AuctionItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          height: 181.h,
          decoration: ShapeDecoration(
            image: const DecorationImage(
              image: NetworkImage("https://placehold.co/370x181/e2e8f0/1e293b?text=Vehicle+Location+Map"),
              fit: BoxFit.cover,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on_outlined, color: const Color(0xFF1B4E9F), size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                [item.country, item.state, item.city, item.zipCode]
                    .where((e) => e.isNotEmpty)
                    .join(', '),
                style: GoogleFonts.outfit(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Comments Section Builder
  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comments',
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        // Add comment input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: GoogleFonts.outfit(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: const BorderSide(color: Color(0xFF1B4E9F)),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () async {
                final text = _commentController.text.trim();
                if (text.isNotEmpty) {
                  final success = await controller.postComment(text);
                  if (success) {
                    _commentController.clear();
                    SnackbarHelper.showSuccess('Comment posted successfully');
                  } else {
                    SnackbarHelper.showError('Failed to post comment');
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: const BoxDecoration(
                  color: Color(0xFF1B4E9F),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send_rounded, color: Colors.white, size: 20.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Comments List
        Obx(() {
          if (controller.isCommentsLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.comments.isEmpty) {
            return Text(
              'No comments yet.',
              style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14.sp),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.comments.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 24.h),
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: const Color(0xFFF1F5F9),
                        backgroundImage: (comment['user_avatar'] != null && comment['user_avatar'].toString().isNotEmpty)
                            ? NetworkImage(comment['user_avatar'])
                            : null,
                        child: (comment['user_avatar'] != null && comment['user_avatar'].toString().isNotEmpty)
                            ? null
                            : Text(
                                (comment['user_name'] != null && comment['user_name'].toString().isNotEmpty)
                                    ? comment['user_name'][0].toUpperCase()
                                    : 'U',
                                style: GoogleFonts.outfit(color: const Color(0xFF1B4E9F), fontWeight: FontWeight.bold),
                              ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          comment['user_name']?.toString() ?? 'User',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14.sp),
                        ),
                      ),
                      Text(
                        _formatTimeAgo(comment['created_at']),
                        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    comment['text'] ?? '',
                    style: GoogleFonts.outfit(fontSize: 14.sp, color: const Color(0xFF2A2A2A)),
                  ),
                ],
              );
            },
          );
        }),
      ],
    );
  }

  // Bottom Sticky Bar builder
  Widget _buildStickyBottomBar(
    BuildContext context,
    AuctionItem item,
    NumberFormat currencyFormat,
    AuctionDetailsController controller,
  ) {
    final bool showBuyNow = item.buyNowPrice != null && item.currentBid < item.buyNowPrice!;

    return Container(
      width: double.infinity,
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: const BoxDecoration(
        color: Color(0xFF1B4E9F),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showBuyNow
                        ? 'Buy without bidding at '
                        : 'Current Bid',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    currencyFormat.format(
                      showBuyNow ? item.buyNowPrice! : item.currentBid,
                    ),
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (showBuyNow)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Purchase'),
                      content: Text('Are you sure you want to buy this vehicle now for ${currencyFormat.format(item.buyNowPrice)}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final errorMsg = await controller.placeBid(item.buyNowPrice!);
                            if (errorMsg == null) {
                              SnackbarHelper.showSuccess('Congratulations! You purchased the vehicle.');
                            } else {
                              SnackbarHelper.showError(errorMsg);
                            }
                          },
                          child: const Text('Buy Now'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 170.w,
                  height: 45.h,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFAC249),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Buy Now    ${currencyFormat.format(item.buyNowPrice)}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF2A2A2A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
