import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../../onboarding/widgets/onboarding_header.dart';
import '../../../../core/constants/app_routes.dart';

class ResetSuccessView extends StatelessWidget {
  const ResetSuccessView({super.key});

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
              SizedBox(height: 50.h),

              // Logo & Company Name Header
              const Center(
                child: OnboardingHeader(),
              ),

              SizedBox(height: 48.h),

              // Blue Circle Checkmark Badge
              Center(
                child: Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4E9F),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Title: "Verified"
              Text(
                'Verified',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2D292E),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),

              SizedBox(height: 12.h),

              // Description Text
              Text(
                'You have successfully verified your account.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xB22D292E),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.10,
                ),
              ),

              SizedBox(height: 32.h),

              // Button: "Login to your Account"
              AppButton(
                text: 'Login to your Account',
                onPressed: () => context.go(AppRoutes.login),
                backgroundColor: const Color(0xFF1B4E9F),
                borderRadius: 8.0,
                height: 41.0,
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
