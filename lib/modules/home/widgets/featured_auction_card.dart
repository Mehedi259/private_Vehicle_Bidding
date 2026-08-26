import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../data/models/auction_item.dart';
import '../../../shared/widgets/countdown_timer_widget.dart';

class FeaturedAuctionCard extends StatelessWidget {
  final AuctionItem item;
  final VoidCallback onPlaceBidTap;
  final VoidCallback? onTap;

  const FeaturedAuctionCard({
    super.key,
    required this.item,
    required this.onPlaceBidTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(name: '\$', decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: Colors.black.withValues(alpha: 0.15),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 96.h,
                    child: item.imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: item.imageUrl,
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
                            errorWidget: (context, url, error) {
                              debugPrint("CachedNetworkImage error for $url: $error");
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          )
                        : (item.imageUrl.startsWith('/') || item.imageUrl.contains(':'))
                            ? Image.file(
                                File(item.imageUrl),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                item.imageUrl,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                if (item.vinVerified || item.verifiedSeller)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF05BE27).withValues(alpha: 0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Verified',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Content Area
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF2A2A2A),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Current Bid',
                    style: GoogleFonts.outfit(
                      color: const Color(0x992A2A2A),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          currencyFormat.format(item.currentBid),
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF1B4E9F),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.gavel_rounded,
                              color: const Color(0xFF1B4E9F),
                              size: 13.sp,
                            ),
                            SizedBox(width: 4.w),
                            Flexible(
                              child: Text(
                                '${item.bidsCount} Bids',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFF1B4E9F),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 14.sp, color: const Color(0xFFF86247)),
                      SizedBox(width: 4.w),
                      Expanded(child: CountdownTimerWidget(endTime: item.endTime)),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: item.hasUserBid ? null : onPlaceBidTap,
                    child: Container(
                      width: double.infinity,
                      height: 28.h,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: item.hasUserBid ? const Color(0xFF9CA3AF) : const Color(0xFF1B4E9F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        item.hasUserBid ? 'Bid Placed' : 'Place Bid',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
