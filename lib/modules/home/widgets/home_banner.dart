import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../shell/controllers/shell_controller.dart';
import '../../../core/constants/custom_assets.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 154.h,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.99, 0.0),
          end: Alignment(0.01, 0.97),
          colors: [Color(0xFF1B4E9F), Color(0xFF091B39)],
        ),
        shape: RoundedRectangleBorder(
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Overlapping vehicles composite image on the right
          Positioned(
            right: 0.w,
            bottom: 0,
            top: 5.h,
            child: Image.asset(
              CustomAssets.homeBannerVehicles,
              width: 220.w,
              fit: BoxFit.contain,
            ),
          ),

          // Content Column on the left
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 180.w,
                    child: Text(
                      'Private Sellers Auctions in USA',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Flexible(
                  child: SizedBox(
                    width: 160.w,
                    child: Text(
                      'Bid on verified vehicles with secure escrow',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    Get.find<ShellController>().changePage(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x28000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Start Bidding',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF1B4E9F),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: const Color(0xFF1B4E9F),
                          size: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
