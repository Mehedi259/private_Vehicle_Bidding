import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../../onboarding/widgets/onboarding_header.dart';
import '../controllers/forgot_password_verification_controller.dart';

class ForgotPasswordVerificationView extends StatefulWidget {
  final String email;

  const ForgotPasswordVerificationView({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordVerificationView> createState() =>
      _ForgotPasswordVerificationViewState();
}

class _ForgotPasswordVerificationViewState
    extends State<ForgotPasswordVerificationView> {
  late final ForgotPasswordVerificationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ForgotPasswordVerificationController());
    controller.setEmail(widget.email);
  }

  @override
  void dispose() {
    Get.delete<ForgotPasswordVerificationController>();
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

                // Logo & Company Name Header
                const Center(
                  child: OnboardingHeader(),
                ),

                SizedBox(height: 32.h),

                // Title: "Verify your email address"
                Text(
                  'Verify your email address',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF2D292E),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),

                SizedBox(height: 10.h),

                // Description: with dynamic email highlighted
                Obx(
                  () => Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'We emailed you a six-digit code to ',
                          style: GoogleFonts.inter(
                            color: const Color(0xB22D292E),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: controller.email.value.isNotEmpty
                              ? controller.email.value
                              : 'name@company.com',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF2D292E),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '. Enter the code below to confirm your email address.',
                          style: GoogleFonts.inter(
                            color: const Color(0xB22D292E),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // 6-digit OTP fields
                _OtpFields(controller: controller),

                SizedBox(height: 24.h),

                // Info text container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Please keep this window open while you check your inbox.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF2D292E),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Verify Button
                Obx(
                  () => AppButton(
                    text: 'Verify',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.verifyCode(context),
                    backgroundColor: const Color(0xFF1B4E9F),
                    borderRadius: 8.0,
                    height: 41.0,
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

class _OtpFields extends StatelessWidget {
  final ForgotPasswordVerificationController controller;

  const _OtpFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildOtpField(controller.otp1Controller, controller.otp1FocusNode, 1, controller.otp1, controller, context),
        _buildOtpField(controller.otp2Controller, controller.otp2FocusNode, 2, controller.otp2, controller, context),
        _buildOtpField(controller.otp3Controller, controller.otp3FocusNode, 3, controller.otp3, controller, context),
        _buildOtpField(controller.otp4Controller, controller.otp4FocusNode, 4, controller.otp4, controller, context),
        _buildOtpField(controller.otp5Controller, controller.otp5FocusNode, 5, controller.otp5, controller, context),
        _buildOtpField(controller.otp6Controller, controller.otp6FocusNode, 6, controller.otp6, controller, context),
      ],
    );
  }

  Widget _buildOtpField(
    TextEditingController textController,
    FocusNode focusNode,
    int index,
    RxString observableValue,
    ForgotPasswordVerificationController otpController,
    BuildContext context,
  ) {
    return Obx(() {
      final hasInput = observableValue.value.isNotEmpty;

      return Container(
        width: 44.w,
        height: 54.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xFF1B4E9F),
            width: hasInput ? 1.5.w : 1.w,
          ),
        ),
        child: Center(
          child: TextFormField(
            controller: textController,
            focusNode: focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D292E),
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            onChanged: (value) {
              if (value.length <= 1) {
                otpController.onOtpChanged(value, index, context);
              }
            },
          ),
        ),
      );
    });
  }
}
