import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_helper.dart';

class ForgotPasswordVerificationController extends GetxController {
  // ─── OTP Text Controllers ──────────────────────────────────────────────────
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();
  final TextEditingController otp5Controller = TextEditingController();
  final TextEditingController otp6Controller = TextEditingController();

  // ─── Focus Nodes ──────────────────────────────────────────────────────────
  final FocusNode otp1FocusNode = FocusNode();
  final FocusNode otp2FocusNode = FocusNode();
  final FocusNode otp3FocusNode = FocusNode();
  final FocusNode otp4FocusNode = FocusNode();
  final FocusNode otp5FocusNode = FocusNode();
  final FocusNode otp6FocusNode = FocusNode();

  // ─── Observable OTP digits ────────────────────────────────────────────────
  final RxString otp1 = ''.obs;
  final RxString otp2 = ''.obs;
  final RxString otp3 = ''.obs;
  final RxString otp4 = ''.obs;
  final RxString otp5 = ''.obs;
  final RxString otp6 = ''.obs;

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxString email = ''.obs;
  final RxBool isLoading = false.obs;

  // ─── Form Key ─────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Public Getters ───────────────────────────────────────────────────────
  String get fullOtp =>
      '${otp1.value}${otp2.value}${otp3.value}${otp4.value}${otp5.value}${otp6.value}';

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onClose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    otp6Controller.dispose();
    otp1FocusNode.dispose();
    otp2FocusNode.dispose();
    otp3FocusNode.dispose();
    otp4FocusNode.dispose();
    otp5FocusNode.dispose();
    otp6FocusNode.dispose();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────────────────
  /// Sets the email address
  void setEmail(String mail) {
    email.value = mail;
  }

  /// Handles OTP field change — auto-moves focus
  void onOtpChanged(String value, int index, BuildContext context) {
    _updateOtpValue(value, index);
    if (value.isNotEmpty && index < 6) {
      _focusNext(index);
    }
    if (value.isEmpty && index > 1) {
      _focusPrev(index);
    }
  }

  /// Verifies the OTP code
  Future<void> verifyCode(BuildContext context) async {
    final otp = fullOtp;
    if (otp.length < 6) {
      SnackbarHelper.showError('Please enter all 6 digits.');
      return;
    }

    isLoading.value = true;
    try {
      // Mock network verification delay
      await Future.delayed(const Duration(milliseconds: 1500));

      if (context.mounted) {
        context.go(AppRoutes.resetPassword);
        SnackbarHelper.showSuccess('Email verified successfully! Please create your new password.');
      }
    } catch (e) {
      SnackbarHelper.showError('Verification failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────
  void _updateOtpValue(String value, int index) {
    switch (index) {
      case 1:
        otp1.value = value;
        break;
      case 2:
        otp2.value = value;
        break;
      case 3:
        otp3.value = value;
        break;
      case 4:
        otp4.value = value;
        break;
      case 5:
        otp5.value = value;
        break;
      case 6:
        otp6.value = value;
        break;
    }
  }

  void _focusNext(int index) {
    switch (index) {
      case 1:
        otp2FocusNode.requestFocus();
        break;
      case 2:
        otp3FocusNode.requestFocus();
        break;
      case 3:
        otp4FocusNode.requestFocus();
        break;
      case 4:
        otp5FocusNode.requestFocus();
        break;
      case 5:
        otp6FocusNode.requestFocus();
        break;
    }
  }

  void _focusPrev(int index) {
    switch (index) {
      case 2:
        otp1FocusNode.requestFocus();
        break;
      case 3:
        otp2FocusNode.requestFocus();
        break;
      case 4:
        otp3FocusNode.requestFocus();
        break;
      case 5:
        otp4FocusNode.requestFocus();
        break;
      case 6:
        otp5FocusNode.requestFocus();
        break;
    }
  }
}
