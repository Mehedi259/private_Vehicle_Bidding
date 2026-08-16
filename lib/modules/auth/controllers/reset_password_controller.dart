import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_helper.dart';

class ResetPasswordController extends GetxController {
  // ─── Text Controllers ──────────────────────────────────────────────────────
  final TextEditingController passwordController = TextEditingController(text: "newpassword123");
  final TextEditingController confirmPasswordController = TextEditingController(text: "newpassword123");

  // ─── Focus Nodes ──────────────────────────────────────────────────────────
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool agreeToPrivacy = true.obs;

  // ─── Form Key ─────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────────────────
  /// Toggles privacy agreement state
  void togglePrivacy() {
    agreeToPrivacy.value = !agreeToPrivacy.value;
  }

  /// Resets the user password
  Future<void> resetPassword(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    if (!agreeToPrivacy.value) {
      SnackbarHelper.showError('You must agree to Bidding Motor’s Privacy Policy.');
      return;
    }

    isLoading.value = true;
    try {
      // Mock network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      if (context.mounted) {
        context.go(AppRoutes.resetSuccess);
        SnackbarHelper.showSuccess('Password reset successfully! Please verify your login.');
      }
    } catch (e) {
      SnackbarHelper.showError('Reset failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigates to Support Contact screen
  void showSupportContact(BuildContext context) {
    context.push(AppRoutes.contactSupport);
  }

  /// Navigates to Privacy Policy screen
  void showPrivacyPolicy(BuildContext context) {
    context.push(AppRoutes.privacyPolicy);
  }
}
