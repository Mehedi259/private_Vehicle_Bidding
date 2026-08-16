import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/models/listed_vehicle.dart';

class ListedVehicleCard extends StatelessWidget {
  final ListedVehicle vehicle;
  final VoidCallback? onTap;

  const ListedVehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUrl = vehicle.imageUrl.startsWith('http');
    final numberFormat = NumberFormat.simpleCurrency(decimalDigits: 0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: Colors.black.withValues(alpha: 0.20),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 6,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image (Top part of Card)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 110.h,
                child: isUrl
                    ? CachedNetworkImage(
                        imageUrl: vehicle.imageUrl,
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
                    : Image.asset(
                        vehicle.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.directions_car_filled_outlined),
                        ),
                      ),
              ),
            ),

            // Card details (Bottom part of Card)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      vehicle.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Last Bid Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Bid',
                          style: GoogleFonts.outfit(
                            color: const Color(0x992A2A2A),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              numberFormat.format(vehicle.lastBid),
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF1B4E9F),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.gavel_outlined,
                                  color: const Color(0xFF1B4E9F),
                                  size: 13.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${vehicle.bidsCount} Bids',
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF1B4E9F),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Sold/Active Status Button Pill
                    Container(
                      width: double.infinity,
                      height: 26.h,
                      alignment: Alignment.center,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF1B4E9F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        vehicle.status == VehicleStatus.sold ? 'Sold' : 'Active',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
}
