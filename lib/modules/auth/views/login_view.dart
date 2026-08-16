import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_email_field.dart';
import '../../../shared/widgets/app_password_field.dart';
import '../../onboarding/widgets/onboarding_header.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

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

                // "Log in" Title Text
                Text(
                  'Log in',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2D292E),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 32.h),

                // Email Input Field
                AppEmailField(
                  controller: controller.emailController,
                ),

                SizedBox(height: 20.h),

                // Password Input Field
                AppPasswordField(
                  controller: controller.passwordController,
                ),

                SizedBox(height: 16.h),

                // Remember Me & Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Custom interactive remember me checkbox
                    Flexible(
                      child: Obx(
                        () => GestureDetector(
                          onTap: controller.toggleRememberMe,
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16.w,
                                height: 16.h,
                                decoration: ShapeDecoration(
                                  color: controller.rememberMe.value
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
                                child: controller.rememberMe.value
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 11.sp,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  'Remember me',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF6B7280),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Forgot Password Button
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.forgotPassword),
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7685C2),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Continue Button
                Obx(
                  () => AppButton(
                    text: 'Continue',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.login(context),
                    backgroundColor: const Color(0xFF1B4E9F),
                    borderRadius: 8.0,
                    height: 48.0,
                  ),
                ),

                SizedBox(height: 24.h),

                // Sign Up Footer
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(AppRoutes.signUp),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don’t have an account yet? ',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF6B7280),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign up',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF7685C2),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
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
