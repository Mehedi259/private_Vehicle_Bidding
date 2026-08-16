import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String hintText;
  final VoidCallback? onFilterTap;
  final Color fillColor;
  final double? height;

  const AppSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = 'Search make, model, type...',
    this.onFilterTap,
    this.fillColor = const Color(0xFFF9FAFB),
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 46.h,
      decoration: ShapeDecoration(
        color: fillColor,
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
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
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
          suffixIcon: onFilterTap != null
              ? GestureDetector(
                  onTap: onFilterTap,
                  child: Icon(
                    Icons.tune_rounded,
                    color: const Color(0xFF1B4E9F),
                    size: 20.sp,
                  ),
                )
              : Icon(
                  Icons.tune_rounded,
                  color: const Color(0xFF1B4E9F),
                  size: 20.sp,
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
      ),
    );
  }
}
