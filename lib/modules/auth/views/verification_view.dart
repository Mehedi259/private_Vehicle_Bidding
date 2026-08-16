import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/interfaces/i_auth_repository.dart';
import '../../../../data/repositories/auth_repository_impl.dart';
import '../../../shared/widgets/app_button.dart';
import '../../onboarding/widgets/onboarding_header.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends StatefulWidget {
  final String? phoneNumber;
  final String? email;

  const VerificationView({
    super.key,
    this.phoneNumber,
    this.email,
  });

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  late final VerificationController controller;

  @override
  void initState() {
    super.initState();
    // Ensure dependencies are registered
    if (!Get.isRegistered<IAuthRepository>()) {
      Get.lazyPut<IAuthRepository>(() => AuthRepositoryImpl());
    }
    controller = Get.put(VerificationController(Get.find<IAuthRepository>()));

    // Inject controllers states if params are present
    if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
      controller.setPhoneNumber(widget.phoneNumber!);
    }
    if (widget.email != null && widget.email!.isNotEmpty) {
      controller.setEmail(widget.email!);
    }
  }

  @override
  void dispose() {
    Get.delete<VerificationController>();
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 32.h),

              // Logo & Company Name Header
              const Center(
                child: OnboardingHeader(),
              ),

              SizedBox(height: 32.h),

              // Title "Verify your email address"
              Text(
                'Verify your email address',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2D292E),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 10.h),

              // Email description rich text
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

              // Please keep this window open info box
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

              SizedBox(height: 12.h),

              // Verify button
              Obx(
                () => AppButton(
                  text: 'Verify',
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.verifyCode(context),
                  backgroundColor: const Color(0xFF1B4E9F),
                  borderRadius: 8.0,
                  height: 48.0,
                ),
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpFields extends StatelessWidget {
  final VerificationController controller;

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
    VerificationController otpController,
    BuildContext context,
  ) {
    return Obx(() {
      final hasInput = observableValue.value.isNotEmpty;

      return Container(
        width: 44.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: hasInput ? const Color(0xFF1B4E9F) : const Color(0xFFD1D5DB),
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
