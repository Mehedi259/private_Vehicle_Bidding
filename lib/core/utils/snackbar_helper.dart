import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFFEFF6FF),
      textColor: const Color(0xFF0249AA),
      icon: Icons.check_circle_rounded,
      iconColor: const Color(0xFF0249AA),
    );
  }

  static void showError(String message) {
    _showSnackBar(
      message: message,
      backgroundColor: const Color(0xFFFEF2F2),
      textColor: const Color(0xFFEF4444),
      icon: Icons.error_outline_rounded,
      iconColor: const Color(0xFFEF4444),
    );
  }

  static void _showSnackBar({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Color iconColor,
  }) {
    final state = messengerKey.currentState;
    if (state == null) return;

    // Immediately clear current snackbars to avoid delay
    state.clearSnackBars();

    state.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: ScreenUtil().screenHeight - 130.h,
          left: 16.w,
          right: 16.w,
        ),
        dismissDirection: DismissDirection.up,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
