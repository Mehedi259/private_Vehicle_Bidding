import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_helper.dart';

class ForgotPasswordController extends GetxController {
  // ─── Text Controllers ──────────────────────────────────────────────────────
  final TextEditingController emailController = TextEditingController(text: "mdshobuj204111@gmail.com");

  // ─── Focus Nodes ──────────────────────────────────────────────────────────
  final FocusNode emailFocusNode = FocusNode();

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool agreeToPrivacy = true.obs;

  // ─── Form Key ─────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onClose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────────────────
  /// Toggles privacy agreement state
  void togglePrivacy() {
    agreeToPrivacy.value = !agreeToPrivacy.value;
  }

  /// Sends the password reset instructions email
  Future<void> sendResetEmail(BuildContext context) async {
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
        context.go('${AppRoutes.forgotPasswordVerification}?email=${Uri.encodeComponent(emailController.text)}');
        SnackbarHelper.showSuccess('Instructions to reset your password have been sent to ${emailController.text}');
      }
    } catch (e) {
      SnackbarHelper.showError('Request failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigates back to login view
  void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  /// Displays Privacy Policy click mock message
  void showPrivacyPolicy() {
    SnackbarHelper.showSuccess('Showing Privacy Policy (Mocked)');
  }

  /// Displays Account Recovery click mock message
  void showAccountRecovery() {
    SnackbarHelper.showSuccess('Starting Account Recovery (Mocked)');
  }
}
