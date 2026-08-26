import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/widgets/app_avatar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/app_dropdown_field.dart';
import '../../../shared/widgets/app_date_picker_field.dart';
import '../controllers/edit_profile_controller.dart';
import '../../../shared/widgets/app_back_button.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
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
                              'Edit Profile',
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

                      // 2. Profile Image Stack with Camera Overlay
                      Center(
                        child: Stack(
                          children: [
                            Obx(() {
                              final path = controller.selectedImagePath.value;
                              final avatarUrl = path.isNotEmpty
                                  ? path
                                  : controller.currentAvatarUrl;
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: AppAvatar(
                                  imageUrl: avatarUrl,
                                  fullName: controller.nameController.text,
                                  radius: 42.r,
                                ),
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => controller.pickImage(),
                                child: Container(
                                  width: 26.r,
                                  height: 26.r,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: const CircleBorder(),
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20.sp,
                                    color: const Color(0xFF323232),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // 3. User Name & Email display labels
                      Center(
                        child: Text(
                          controller.nameController.text,
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF323232),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Center(
                        child: Text(
                          controller.emailController.text,
                          style: GoogleFonts.manrope(
                            color: const Color(0x7F323232),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // 4. Section Title
                      Text(
                        'Personal Information',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF323232),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // 5. Form Fields
                      // Full Name
                      AppTextField(
                        labelText: 'Full Name',
                        controller: controller.nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Email Address
                      AppTextField(
                        labelText: 'Email Address',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!GetUtils.isEmail(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Phone Number
                      AppTextField(
                        labelText: 'Phone Number',
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Address
                      AppTextField(
                        labelText: 'Address',
                        controller: controller.addressController,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Date of Birth
                      Obx(
                        () => AppDatePickerField(
                          labelText: 'Date of Birth',
                          selectedDate: controller.dob.value,
                          onTap: () => controller.selectDate(context),
                          hintText: 'Select Date of Birth',
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Gender
                      Obx(
                        () => AppDropdownField(
                          labelText: 'Gender',
                          value: controller.gender.value,
                          items: const ['Male', 'Female', 'Other'],
                          onChanged: (value) {
                            if (value != null) {
                              controller.gender.value = value;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Save Button
                      Obx(
                        () => AppButton(
                          text: 'Save',
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.saveProfile(context),
                          backgroundColor: const Color(0xFF1B4E9F),
                          textColor: Colors.white,
                          height: 41.h,
                          borderRadius: 8.r,
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                      SizedBox(height: 40.h),
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
