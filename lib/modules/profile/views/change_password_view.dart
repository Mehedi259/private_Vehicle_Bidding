import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_password_field.dart';
import '../../../shared/widgets/app_confirm_password_field.dart';
import '../controllers/change_password_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasswordController>(
      init: ChangePasswordController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: controller.formKey,
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
                              'Change Password',
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

                      // 2. Password Inputs
                      AppPasswordField(
                        labelText: 'Current Password',
                        hintText: '********',
                        controller: controller.currentPasswordController,
                      ),
                      SizedBox(height: 24.h),

                      AppPasswordField(
                        labelText: 'New Password',
                        hintText: '********',
                        controller: controller.newPasswordController,
                      ),
                      SizedBox(height: 24.h),

                      AppConfirmPasswordField(
                        labelText: 'Confirm Password',
                        hintText: '********',
                        controller: controller.confirmPasswordController,
                        passwordController: controller.newPasswordController,
                      ),
                      SizedBox(height: 40.h),

                      // 3. Save Button
                      Obx(() => AppButton(
                            text: 'Save',
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.savePassword(context),
                            backgroundColor: const Color(0xFF1B4E9F),
                            textColor: Colors.white,
                            height: 41.h,
                            borderRadius: 8.r,
                            isLoading: controller.isLoading.value,
                          )),

                      // Bottom spacing
                      SizedBox(height: 100.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
