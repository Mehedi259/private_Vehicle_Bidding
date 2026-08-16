import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingActionBar extends StatelessWidget {
  final String buttonText;
  final int currentIndex;
  final VoidCallback onNextTap;

  const OnboardingActionBar({
    super.key,
    required this.buttonText,
    required this.currentIndex,
    required this.onNextTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.27),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFC4C4C4),
          ),
          borderRadius: BorderRadius.circular(56.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10.3,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dynamic Button
          Flexible(
            child: GestureDetector(
              onTap: onNextTap,
              child: Container(
                height: 47.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: ShapeDecoration(
                  color: const Color(0xFF1B4E9F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(37.r),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Progress Indicator Rotated Arrows
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.w,
            children: List.generate(
              5,
              (arrowIndex) {
                final double opacity = ((arrowIndex + 1) / 5) * (currentIndex == 2 ? 1.0 : 0.7);

                return Opacity(
                  opacity: opacity,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFF4CAF50),
                    size: 20.sp,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
