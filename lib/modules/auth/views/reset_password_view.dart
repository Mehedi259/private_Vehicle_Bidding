import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_confirm_password_field.dart';
import '../../../shared/widgets/app_password_field.dart';
import '../../onboarding/widgets/onboarding_header.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late final ResetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ResetPasswordController());
  }

  @override
  void dispose() {
    Get.delete<ResetPasswordController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50.h),

                // Logo and Company Name Header
                const Center(
                  child: OnboardingHeader(),
                ),

                SizedBox(height: 32.h),

                // Title: "Create new password"
                Text(
                  'Create new password',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2D292E),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),

                SizedBox(height: 8.h),

                // Subtitle description
                Text(
                  'Your new password must be different from previous used passwords.',
                  style: GoogleFonts.inter(
                    color: const Color(0xB22D292E),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 32.h),

                // New Password Input Field
                AppPasswordField(
                  controller: controller.passwordController,
                  labelText: 'New Password',
                ),

                SizedBox(height: 20.h),

                // Confirm Password Input Field
                AppConfirmPasswordField(
                  controller: controller.confirmPasswordController,
                  passwordController: controller.passwordController,
                  labelText: 'Confirm Password',
                ),

                SizedBox(height: 24.h),

                // Custom Interactive Privacy Policy Checkbox
                Obx(
                  () => GestureDetector(
                    key: const Key('privacy_checkbox_gesture'),
                    onTap: controller.togglePrivacy,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          key: const Key('privacy_checkbox_icon'),
                          width: 16.w,
                          height: 16.h,
                          margin: EdgeInsets.only(top: 2.h),
                          decoration: ShapeDecoration(
                            color: controller.agreeToPrivacy.value
                                ? const Color(0xFF1B4E9F)
                                : const Color(0xFFF9FAFB),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.w,
                                color: const Color(0xFFD1D5DB),
                              ),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          child: controller.agreeToPrivacy.value
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 11.sp,
                                )
                              : null,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I agree to A ',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xB22D292E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Bidding Motor’s',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF111928),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xB22D292E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF7685C2),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => controller.showPrivacyPolicy(context),
                                ),
                                TextSpan(
                                  text: '.',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xB22D292E),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Button: Forget Password
                Obx(
                  () => AppButton(
                    text: 'Confirm',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.resetPassword(context),
                    backgroundColor: const Color(0xFF1B4E9F),
                    borderRadius: 8.0,
                    height: 41.0,
                  ),
                ),

                SizedBox(height: 20.h),

                // Subtext footer
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'If you still need help, contact',
                        style: GoogleFonts.inter(
                          color: const Color(0xB22D292E),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: ' Support.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7685C2),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => controller.showSupportContact(context),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
