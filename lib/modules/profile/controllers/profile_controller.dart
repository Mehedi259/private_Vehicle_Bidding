import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/interfaces/i_auth_repository.dart';
import '../../../core/services/shared_prefs_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/models/user_model.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  // Observable user state
  final Rx<UserModel> user = const UserModel(
    id: '',
    name: 'Loading...',
    email: 'Loading...',
    avatarUrl: '',
    dob: '',
    gender: '',
  ).obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetch user profile from backend
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await ApiService.get('/accounts/user/profile/', requireAuth: true);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? avatarUrl = data['image'];
        if (avatarUrl != null && avatarUrl.startsWith('/')) {
          avatarUrl = '${ApiService.baseUrl}$avatarUrl';
        }

        user.value = UserModel(
          id: data['id']?.toString() ?? '',
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          avatarUrl: avatarUrl ?? '',
          dob: data['dob'] ?? '',
          gender: data['gender'] ?? '',
        );
      }
    } catch (e) {
      debugPrint('Failed to fetch profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Trigger edit profile flow
  void editProfile(BuildContext context) {
    context.push(AppRoutes.editProfile);
  }

  /// Trigger payment methods flow
  void managePaymentMethods(BuildContext context) {
    context.push(AppRoutes.paymentMethods);
  }

  /// Trigger verification flow
  void verifyProfile(BuildContext context) {
    context.push(AppRoutes.profileVerification);
  }

  /// Trigger subscription flow
  void manageSubscription() {
    SnackbarHelper.showSuccess('Subscription clicked.');
  }

  /// Trigger security settings flow
  void manageSecurity(BuildContext context) {
    context.push(AppRoutes.security);
  }

  /// Trigger support & help flow
  void getHelp(BuildContext context) {
    context.push(AppRoutes.supportHelp);
  }

  /// Perform logout
  void logout(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color(0x7F474747),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: 370.w,
            height: 219.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFEFEFE),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Icon(
                      Icons.close_rounded,
                      color: const Color.fromARGB(255, 252, 3, 3),
                      size: 20.sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 32.h,
                  child: Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF4F7FD),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: const Color(0xFF1B4E9F),
                      size: 24.sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 94.h,
                  child: Text(
                    'Logout from the app',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF3C3C3C),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.10,
                    ),
                  ),
                ),
                Positioned(
                  top: 146.h,
                  child: SizedBox(
                    width: 234.w,
                    height: 41.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        await SharedPrefsService.clearAuth();
                        ApiService.clearCookies();
                        Get.deleteAll(force: true); // Clear all memory state
                        if (context.mounted) {
                          context.go(AppRoutes.login);
                          SnackbarHelper.showSuccess('Logged out successfully!');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4E9F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
