import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const AppFaqTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<AppFaqTile> createState() => _AppFaqTileState();
}

class _AppFaqTileState extends State<AppFaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
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
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF2A2A2A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF1B4E9F),
                  size: 24.sp,
                ),
              ],
            ),
            if (_isExpanded) ...[
              SizedBox(height: 8.h),
              Text(
                widget.answer,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2A2A2A).withValues(alpha: 0.70),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.30,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
