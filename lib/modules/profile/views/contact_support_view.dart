import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../controllers/contact_support_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class ContactSupportView extends StatelessWidget {
  const ContactSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactSupportController>(
      init: ContactSupportController(),
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
                              'Contact Support',
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
                      SizedBox(height: 32.h),

                      // 2. Intro Text
                      Text(
                        'If you’re facing an issue or need help, we’re here for you. Describe your problem and we’ll get back to you as soon as possible.',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF323232).withValues(alpha: 0.70),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // 3. Subject Input
                      AppTextField(
                        labelText: 'Subject',
                        hintText: 'Short title of your issue',
                        controller: controller.subjectController,
                        isRequired: true,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                             return 'Please enter a subject';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // 4. Email Address Input
                      AppTextField(
                        labelText: 'Email Address',
                        hintText: 'Write your email',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        isRequired: true,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!GetUtils.isEmail(val.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // 5. Message Input
                      AppTextField(
                        labelText: 'Message',
                        hintText: 'Please explain what happened...',
                        controller: controller.messageController,
                        isRequired: true,
                        maxLines: 4,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please explain your issue';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // 6. Attach Screenshot
                      Obx(() {
                        final hasScreenshot = controller.selectedScreenshotPath.value.isNotEmpty;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attach Screenshot (if relevant)',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF2D292E),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: controller.pickScreenshot,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: const Color(0xFF1B4E9F),
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Text(
                                              hasScreenshot
                                                  ? controller.selectedScreenshotPath.value.split('/').last
                                                  : 'Choose image file...',
                                              style: GoogleFonts.poppins(
                                                color: hasScreenshot ? const Color(0xFF323232) : const Color(0xFF6B7280),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (hasScreenshot)
                                      GestureDetector(
                                        onTap: () {
                                          controller.clearScreenshot();
                                        },
                                        child: Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.red,
                                          size: 20.sp,
                                        ),
                                      )
                                    else
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: const Color(0xFF6B7280),
                                        size: 20.sp,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 40.h),

                      // 7. Send Button
                      Obx(() => AppButton(
                            text: 'Send Message',
                            onPressed: controller.isLoading.value
                                ? null
                                : () => controller.submitTicket(context),
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
