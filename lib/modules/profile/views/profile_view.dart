import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_list_tile.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  final user = controller.user.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header (Title)
                      Padding(
                        padding: EdgeInsets.only(top: 24.h),
                        child: Text(
                          'My Profile',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF2A2A2A),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // 2. Avatar / Profile Image
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 3.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: AppAvatar(
                            imageUrl: user.avatarUrl,
                            fullName: user.name,
                            radius: 42.r,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 3. User Name
                      Center(
                        child: Text(
                          user.name,
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF323232),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // 4. User Email
                      Center(
                        child: Text(
                          user.email,
                          style: GoogleFonts.manrope(
                            color: const Color(0x7F323232),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // 5. Menu List Items
                      AppListTile(
                        title: 'Edit Profile',
                        leadingIcon: Icons.person_outline_rounded,
                        showIconBorder: false,
                        onTap: () => controller.editProfile(context),
                      ),
                      SizedBox(height: 12.h),

                      AppListTile(
                        title: 'Verification',
                        leadingIcon: Icons.verified_outlined,
                        showIconBorder: false,
                        onTap: () => controller.verifyProfile(context),
                      ),
                      SizedBox(height: 12.h),

                      AppListTile(
                        title: 'Payment Methods',
                        leadingIcon: Icons.credit_card_outlined,
                        showIconBorder: false,
                        onTap: () => controller.managePaymentMethods(context),
                      ),
                      SizedBox(height: 12.h),

                      AppListTile(
                        title: 'Subscription',
                        leadingIcon: Icons.receipt_long_outlined,
                        showIconBorder: false,
                        onTap: () => controller.manageSubscription(),
                      ),
                      SizedBox(height: 12.h),

                      AppListTile(
                        title: 'Security',
                        leadingIcon: Icons.security_outlined,
                        showIconBorder: true,
                        onTap: () => controller.manageSecurity(context),
                      ),
                      SizedBox(height: 12.h),

                      AppListTile(
                        title: 'Support & Help',
                        leadingIcon: Icons.headset_mic_outlined,
                        showIconBorder: true,
                        onTap: () => controller.getHelp(context),
                      ),
                      SizedBox(height: 12.h),

                      AppListTile(
                        title: 'Logout',
                        leadingIcon: Icons.logout_rounded,
                        showIconBorder: true,
                        onTap: () => controller.logout(context),
                      ),

                      // Bottom spacing to prevent layout overlap by bottom nav bar
                      SizedBox(height: 100.h),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
