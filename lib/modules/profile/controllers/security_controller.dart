import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/snackbar_helper.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';
import '../../../core/services/shared_prefs_service.dart';
import 'profile_controller.dart';

class SecurityController extends GetxController {
  // Observables for switch states
  final RxBool isLoginActivityEnabled = true.obs;
  final RxBool isVerificationEnabled = true.obs;
  final RxBool isLoading = false.obs;

  /// Toggles the Login Activity setting
  void toggleLoginActivity(bool value) {
    isLoginActivityEnabled.value = value;
    SnackbarHelper.showSuccess(
      value ? 'Login activity tracking enabled.' : 'Login activity tracking disabled.',
    );
  }

  /// Toggles the Email & Phone Verification setting
  void toggleVerification(bool value) {
    isVerificationEnabled.value = value;
    SnackbarHelper.showSuccess(
      value ? 'Two-step verification enabled.' : 'Two-step verification disabled.',
    );
  }

  /// Action when Change Password is clicked
  void changePassword(BuildContext context) {
    context.push(AppRoutes.changePassword);
  }

  /// Action when Delete Account is clicked
  void deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                isLoading.value = true;
                try {
                  final profileController = Get.find<ProfileController>();
                  final email = profileController.user.value.email;

                  final response = await ApiService.delete(
                    '/accounts/user/delete-account/',
                    {'email': email},
                    requireAuth: true,
                  );

                  if (response.statusCode == 200 || response.statusCode == 204) {
                    await SharedPrefsService.clearAuth();
                    if (context.mounted) {
                      context.go(AppRoutes.login);
                      SnackbarHelper.showSuccess('Account deleted successfully.');
                    }
                  } else {
                    final error = jsonDecode(response.body);
                    SnackbarHelper.showError(error['message'] ?? 'Failed to delete account.');
                  }
                } catch (e) {
                  SnackbarHelper.showError('Delete failed: ${e.toString()}');
                } finally {
                  isLoading.value = false;
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
