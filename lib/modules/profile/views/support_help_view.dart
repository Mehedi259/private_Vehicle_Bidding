import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_list_tile.dart';
import '../controllers/support_help_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class SupportHelpView extends StatelessWidget {
  const SupportHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportHelpController>(
      init: SupportHelpController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                            'Support & Help',
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

                    // 2. Help Items List
                    AppListTile(
                      title: 'FAQs',
                      onTap: () => controller.openFaqs(context),
                      showTrailingIcon: false,
                      leading: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF323232),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    AppListTile(
                      title: 'Report a Problem',
                      onTap: () => controller.reportProblem(context),
                      showTrailingIcon: false,
                      leading: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF323232),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    AppListTile(
                      title: 'Privacy Policy',
                      onTap: () => controller.openPrivacyPolicy(context),
                      showTrailingIcon: false,
                      leading: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF323232),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    AppListTile(
                      title: 'Terms & Conditions',
                      onTap: () => controller.openTermsConditions(context),
                      showTrailingIcon: false,
                      leading: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const ShapeDecoration(
                          color: Color(0xFF323232),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),

                    // Bottom spacing
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
