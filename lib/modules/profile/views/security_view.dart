import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_security_tile.dart';
import '../../../shared/widgets/app_switch.dart';
import '../controllers/security_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecurityController>(
      init: SecurityController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Navigation / Header Row
                    Padding(
                      padding: EdgeInsets.only(top: 24.h),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: AppBackButton(),
                          ),
                          Text(
                            'Security',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF323232),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48.h),

                    // 2. Settings Items List
                    // Change Password
                    AppSecurityTile(
                      title: 'Change Password',
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        size: 24.sp,
                        color: const Color(0xFF323232),
                      ),
                      onTap: () => controller.changePassword(context),
                    ),
                    SizedBox(height: 16.h),

                    // Login Activity
                    Obx(
                      () => AppSecurityTile(
                        title: 'Login Activity',
                        trailing: AppSwitch(
                          value: controller.isLoginActivityEnabled.value,
                          onChanged: controller.toggleLoginActivity,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Email & Phone Verification
                    Obx(
                      () => AppSecurityTile(
                        title: 'Email & Phone verification',
                        trailing: AppSwitch(
                          value: controller.isVerificationEnabled.value,
                          onChanged: controller.toggleVerification,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Delete Account
                    AppSecurityTile(
                      title: 'Delete Account',
                      titleColor: const Color(0xFFF86247),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        size: 24.sp,
                        color: const Color(0xFFF86247),
                      ),
                      onTap: () => controller.deleteAccount(context),
                    ),
                    
                    // Bottom Spacing for visual comfort and preventing cutouts
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
