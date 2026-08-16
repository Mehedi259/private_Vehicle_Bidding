import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final bool isSelected; // Added isSelected support for active filter state

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68.w,
        height: 57.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEFF5FF) : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: isSelected
                  ? const Color(0xFF1B4E9F)
                  : Colors.black.withValues(alpha: 0.10),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFF7C7C7C),
              size: 22.sp,
            ),
            SizedBox(height: 2.h),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFF2A2A2A),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
