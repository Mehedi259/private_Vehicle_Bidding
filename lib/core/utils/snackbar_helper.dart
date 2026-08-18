import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  SnackbarHelper._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _showSnackBar(
      title: 'Success',
      message: message,
      backgroundColor: const Color(0xFFEFF6FF),
      textColor: const Color(0xFF0249AA),
      icon: Icons.check_circle_rounded,
      iconColor: const Color(0xFF0249AA),
    );
  }

  static void showError(String message) {
    _showSnackBar(
      title: 'Error',
      message: message,
      backgroundColor: const Color(0xFFFEF2F2),
      textColor: const Color(0xFFEF4444),
      icon: Icons.error_outline_rounded,
      iconColor: const Color(0xFFEF4444),
    );
  }

  static void _showSnackBar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Color iconColor,
  }) {
    messengerKey.currentState?.clearSnackBars();
    
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor, size: 20.r),
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
        margin: EdgeInsets.all(16.w), // Safe margin to prevent Scaffold layout exceptions
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }
}
