import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../controllers/profile_verification_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class ProfileVerificationView extends StatelessWidget {
  const ProfileVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileVerificationController>(
      init: ProfileVerificationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Navigation Header
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
                            'Verification',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF323232),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // 2. Government ID Upload Heading
                    Text(
                      'Government ID Upload',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Document Selectors
                    Obx(() {
                      final selected = controller.selectedDocType.value;

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDocTypeButton(
                                  label: 'Driving License',
                                  isSelected: selected == DocumentType.drivingLicense,
                                  onTap: () => controller.selectDocumentType(DocumentType.drivingLicense),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: _buildDocTypeButton(
                                  label: 'Passport',
                                  isSelected: selected == DocumentType.passport,
                                  onTap: () => controller.selectDocumentType(DocumentType.passport),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _buildDocTypeButton(
                            label: 'State ID',
                            isSelected: selected == DocumentType.stateId,
                            onTap: () => controller.selectDocumentType(DocumentType.stateId),
                            width: double.infinity,
                          ),
                        ],
                      );
                    }),
                    SizedBox(height: 32.h),

                    // 3. Selfie Verification Heading
                    Text(
                      'Selfie Verification',
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Selfie Upload Card
                    Obx(() {
                      final imagePath = controller.selfieImagePath.value;
                      final hasImage = imagePath.isNotEmpty;

                      return GestureDetector(
                        onTap: () => controller.takeSelfie(),
                        child: Container(
                          width: double.infinity,
                          height: 151.h,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF9FAFB),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 2.w,
                                color: const Color(0xFF1B4E9F), // Primary Color
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: hasImage
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        File(imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cached_rounded,
                                              color: Colors.white,
                                              size: 32.sp,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Tap to retake picture',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      size: 24.sp,
                                      color: const Color(0xFF1B4E9F),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Take a Picture',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF1B4E9F),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                      ),
                                    ),
                                    Text(
                                      'Take a clear selfie to verify it’s you.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF1B4E9F),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    }),
                    SizedBox(height: 307.h),

                    // Save Button
                    Obx(() => AppButton(
                          text: 'Save',
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.saveVerification(context),
                          backgroundColor: const Color(0xFF1B4E9F),
                          textColor: Colors.white,
                          height: 41.h,
                          borderRadius: 8.r,
                          isLoading: controller.isLoading.value,
                        )),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocTypeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEFF5FF) : const Color(0xFFE6E7E9),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.w,
              color: isSelected
                  ? const Color(0xFF1B4E9F)
                  : Colors.black.withOpacity(0.20),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 6,
              offset: Offset(0, 3),
              spreadRadius: 0,
            )
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? const Color(0xFF1B4E9F) : const Color(0xFF2A2A2A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
