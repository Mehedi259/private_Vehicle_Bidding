import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingPageContent extends StatelessWidget {
  final OnboardingStepModel step;
  final int index;

  const OnboardingPageContent({
    super.key,
    required this.step,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = index == 2 ? 380.h : 400.h;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration Image
          Center(
            child: Container(
              width: 368.w,
              height: imageHeight,
              margin: EdgeInsets.symmetric(horizontal: 17.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(step.imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          // Titles and Descriptions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: SizedBox(
              width: 316.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(index),
                  SizedBox(height: 10.h),
                  Text(
                    step.description,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF4D4C4C),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
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

  Widget _buildTitle(int index) {
    if (index == 0) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Buy & Sell Vehicles ',
              style: GoogleFonts.outfit(
                color: const Color(0xFF2A2A2A),
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'Safely',
              style: GoogleFonts.outfit(
                color: const Color(0xFF1B4E9F),
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else if (index == 1) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Verified ',
              style: GoogleFonts.outfit(
                color: const Color(0xFF1B4E9F),
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'Sellers Only',
              style: GoogleFonts.outfit(
                color: const Color(0xFF2A2A2A),
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Bid ',
              style: GoogleFonts.outfit(
                color: const Color(0xFF1B4E9F),
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: 'With Confidence',
              style: GoogleFonts.outfit(
                color: const Color(0xFF2A2A2A),
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
  }
}
