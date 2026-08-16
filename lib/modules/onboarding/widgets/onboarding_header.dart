import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/custom_assets.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100.w,
          height: 64.h,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(CustomAssets.logo),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      //  SizedBox(height: 8.h),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Bidding ',
                style: GoogleFonts.oswald(
                  color: const Color(0xFF1B4E9F),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Motors',
                style: GoogleFonts.oswald(
                  color: const Color(0xFF2A2A2A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2.h),
        Text(
          "America's Trusted Vehicle Auction Marketplace",
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: const Color(0xFF2A2A2A),
            fontSize: 8.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
