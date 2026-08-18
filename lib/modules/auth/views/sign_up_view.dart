import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_confirm_password_field.dart';
import '../../../shared/widgets/app_email_field.dart';
import '../../../shared/widgets/app_full_name_field.dart';
import '../../../shared/widgets/app_password_field.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../onboarding/widgets/onboarding_header.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());

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
                SizedBox(height: 32.h),

                // Logo & Company Name Header
                const Center(
                  child: OnboardingHeader(),
                ),

                SizedBox(height: 32.h),

                // "Create your free account" Title Text
                Text(
                  'Create your free account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2D292E),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 24.h),

                // Email Field
                AppEmailField(
                  controller: controller.emailController,
                ),

                SizedBox(height: 16.h),

                // Full Name Field
                AppFullNameField(
                  hintText: 'John Doe',
                  controller: controller.fullNameController,
                ),

                SizedBox(height: 16.h),

                // Phone Number Field
                AppTextField(
                  labelText: 'Phone Number',
                  hintText: '+1 234 567 890',
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),

                SizedBox(height: 16.h),

                // Address Field
                AppTextField(
                  labelText: 'Address',
                  hintText: '123 Main Street',
                  controller: controller.addressController,
                  keyboardType: TextInputType.streetAddress,
                  validator: Validators.validateAddress,
                ),

                SizedBox(height: 16.h),

                // Password Field
                AppPasswordField(
                  hintText: '********',
                  controller: controller.passwordController,
                ),

                SizedBox(height: 16.h),

                // Confirm Password Field
                AppConfirmPasswordField(
                  hintText: '********',
                  controller: controller.confirmPasswordController,
                  passwordController: controller.passwordController,
                ),

                SizedBox(height: 16.h),

                // Terms and Conditions checkbox row
                Obx(
                  () => GestureDetector(
                    key: const Key('terms_checkbox_gesture'),
                    onTap: controller.toggleAcceptTerms,
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: ShapeDecoration(
                            color: controller.acceptTerms.value
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
                          child: controller.acceptTerms.value
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 11.sp,
                                )
                              : null,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: GestureDetector(
                            onTap: () => controller.showTermsAndConditions(context),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'I accept the ',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF6B7280),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms and Conditions',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF7685C2),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Create Account Button
                Obx(
                  () => AppButton(
                    text: 'Create account',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.createAccount(context),
                    backgroundColor: const Color(0xFF1B4E9F),
                    borderRadius: 8.0,
                    height: 48.0,
                  ),
                ),

                SizedBox(height: 16.h),

                // "Already have an account?" Footer Link
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Text(
                      'Already have an account?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7685C2),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
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
