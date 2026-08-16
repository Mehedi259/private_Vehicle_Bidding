import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';

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

      // Simulate API call for password update
      await Future.delayed(const Duration(milliseconds: 1000));
      
      isLoading.value = false;

      if (context.mounted) {
        SnackbarHelper.showSuccess('Password changed successfully.');
        Navigator.of(context).pop(); // Go back to Security screen
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
