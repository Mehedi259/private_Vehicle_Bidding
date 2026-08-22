import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _showCustomSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: const Color(0xFFF0FDF4),
      textColor: const Color(0xFF166534),
      icon: Icons.check_circle_rounded,
      iconColor: const Color(0xFF16A34A),
      indicatorColor: const Color(0xFF22C55E),
    );
  }

  static void showError(String message) {
    _showCustomSnackbar(
      title: 'Error',
      message: message,
      backgroundColor: const Color(0xFFFEF2F2),
      textColor: const Color(0xFF991B1B),
      icon: Icons.error_outline_rounded,
      iconColor: const Color(0xFFDC2626),
      indicatorColor: const Color(0xFFEF4444),
    );
  }

  static void _showCustomSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Color iconColor,
    required Color indicatorColor,
  }) {
    messengerKey.currentState?.clearSnackBars();
    
    // We use a floating snackbar with a very large bottom margin to push it to the top.
    // ScreenUtil is initialized, so 1.sh represents the screen height.
    // The snackbar height is roughly 100.h, so we subtract 150.h to place it near the top.
    final bottomMargin = 1.sh - 150.h;
    
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        margin: EdgeInsets.only(
          bottom: bottomMargin > 0 ? bottomMargin : 0, 
          left: 16.w, 
          right: 16.w
        ),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 4),
        content: Container(
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: indicatorColor.withOpacity(0.3), width: 1.w),
            boxShadow: [
              BoxShadow(
                color: indicatorColor.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Left Indicator Line
                Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(icon, color: iconColor, size: 28.sp),
                SizedBox(width: 16.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        message,
                        style: GoogleFonts.outfit(
                          color: textColor.withOpacity(0.95),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
