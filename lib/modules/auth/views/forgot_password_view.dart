import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_email_field.dart';
import '../../onboarding/widgets/onboarding_header.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final ForgotPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ForgotPasswordController());
  }

  @override
  void dispose() {
    Get.delete<ForgotPasswordController>();
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

                SizedBox(height: 48.h),

                // "Forget your password" Title
                Text(
                  'Forget your password',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2D292E),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),

                SizedBox(height: 12.h),

                // Subtitle description with clickable "account recovery" link
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'We’ll email you instructions to reset your password. If you don’t have access to your email anymore, you can try ',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF2D292E),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: 'account recovery',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7685C2),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = controller.showAccountRecovery,
                      ),
                      TextSpan(
                        text: '.',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Email field
                AppEmailField(
                  controller: controller.emailController,
                  hintText: 'Enter your email',
                ),

                SizedBox(height: 20.h),

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
                                  text: 'I agree to Bidding Motor’s ',
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
                                    ..onTap = controller.showPrivacyPolicy,
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

                // Buttons: Forget Password and Return to Login
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Obx(
                        () => AppButton(
                          text: 'Forget password',
                          isLoading: controller.isLoading.value,
                          onPressed: () => controller.sendResetEmail(context),
                          backgroundColor: const Color(0xFF1B4E9F),
                          borderRadius: 8.0,
                          height: 41.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      flex: 5,
                      child: GestureDetector(
                        onTap: () => controller.goToLogin(context),
                        child: Text(
                          'Return to login',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF7685C2),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
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
