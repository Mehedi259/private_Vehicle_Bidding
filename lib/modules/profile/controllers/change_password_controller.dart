import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import 'dart:convert';
import '../../../core/services/api_service.dart';

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool isLoading = false.obs;

  /// Validates and saves the new password
  Future<void> savePassword(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      isLoading.value = true;

      try {
        final response = await ApiService.post(
          '/accounts/user/change-password/',
          {
            'current_password': currentPasswordController.text,
            'new_password': newPasswordController.text,
            'confirm_new_password': confirmPasswordController.text,
          },
          requireAuth: true,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (context.mounted) {
            SnackbarHelper.showSuccess('Password changed successfully.');
            Navigator.of(context).pop(); // Go back to Security screen
          }
        } else {
          final error = jsonDecode(response.body);
          SnackbarHelper.showError(error['message'] ?? 'Failed to change password.');
        }
      } catch (e) {
        SnackbarHelper.showError('Change password failed: ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
