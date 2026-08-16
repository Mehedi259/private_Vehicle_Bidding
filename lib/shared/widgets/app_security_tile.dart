import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSecurityTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  final Color titleColor;

  const AppSecurityTile({
    super.key,
    required this.title,
    required this.trailing,
    this.onTap,
    this.titleColor = const Color(0xFF323232),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 370.w,
        padding: EdgeInsets.all(12.r),
        decoration: ShapeDecoration(
          color: const Color(0xFFF0F0F0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: const Color(0x7FFEFEFE),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 6,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: titleColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 16.w),
            trailing,
          ],
        ),
      ),
    );
  }
}
