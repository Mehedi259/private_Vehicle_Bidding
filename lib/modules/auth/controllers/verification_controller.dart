import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/interfaces/i_auth_repository.dart';
import '../../../../core/utils/snackbar_helper.dart';

class VerificationController extends GetxController {
  final IAuthRepository _authRepository;

  VerificationController(this._authRepository);
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
  final RxBool isLoading = false.obs;
  final RxString phoneNumber = ''.obs;
  final RxString email = ''.obs;
  final RxInt remainingSeconds = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _timer;

  // ─── Form ─────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Public Getters ───────────────────────────────────────────────────────
  String get fullOtp =>
      '${otp1.value}${otp2.value}${otp3.value}${otp4.value}${otp5.value}${otp6.value}';
  String get timerText {
    final m = (remainingSeconds.value ~/ 60).toString().padLeft(1, '0');
    final s = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    _stopTimer();
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

  /// Sets phone number
  void setPhoneNumber(String number) {
    phoneNumber.value = number;
  }

  /// Sets email address
  void setEmail(String mail) {
    email.value = mail;
  }

  /// Handles single OTP field change — auto-moves focus
  void onOtpChanged(String value, int index, BuildContext context) {
    _updateOtpValue(value, index);
    if (value.isNotEmpty && index < 6) _focusNext(index);
    if (value.isEmpty && index > 1) _focusPrev(index);
  }

  /// Pastes OTP from clipboard
  Future<void> handlePasteFromClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final digits = (data?.text ?? '').replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length >= 6) {
        _fillAllOtpFields(digits.substring(0, 6));
        otp6FocusNode.requestFocus();
      }
    } catch (_) {
      debugPrint('Failed to paste code');
    }
  }

  /// Verifies OTP
  Future<void> verifyCode(BuildContext context) async {
    final otp = fullOtp;
    if (otp.length < 6) {
      SnackbarHelper.showError('Please enter all 6 digits.');
      return;
    }

    isLoading.value = true;
    try {
      final identifier = email.value.isNotEmpty ? email.value : phoneNumber.value;
      final success = await _authRepository.verifyOtp(identifier, otp);
      if (success) {
        if (context.mounted) {
          context.go(AppRoutes.home);
        }
      } else {
        SnackbarHelper.showError('The code you entered is incorrect. Try again.');
      }
    } catch (e) {
      SnackbarHelper.showError('Verification failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Resends OTP
  Future<void> resendCode() async {
    if (!canResend.value) return;

    isLoading.value = true;
    try {
      final identifier = email.value.isNotEmpty ? email.value : phoneNumber.value;
      final success = await _authRepository.resendOtp(identifier);
      if (success) {
        _clearAllFields();
        _startTimer();
        otp1FocusNode.requestFocus();
        SnackbarHelper.showSuccess('OTP resent successfully.');
      } else {
        SnackbarHelper.showError('Failed to resend OTP.');
      }
    } catch (e) {
      SnackbarHelper.showError('Failed to resend OTP: $e');
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

  void _focusNext(int i) {
    switch (i) {
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

  void _focusPrev(int i) {
    switch (i) {
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

  void _fillAllOtpFields(String digits) {
    final controllers = [
      otp1Controller,
      otp2Controller,
      otp3Controller,
      otp4Controller,
      otp5Controller,
      otp6Controller,
    ];
    final observables = [otp1, otp2, otp3, otp4, otp5, otp6];
    for (int i = 0; i < 6; i++) {
      controllers[i].text = digits[i];
      observables[i].value = digits[i];
    }
  }

  void _clearAllFields() {
    for (final c in [
      otp1Controller,
      otp2Controller,
      otp3Controller,
      otp4Controller,
      otp5Controller,
      otp6Controller,
    ]) {
      c.clear();
    }
    for (final o in [otp1, otp2, otp3, otp4, otp5, otp6]) {
      o.value = '';
    }
  }

  void _startTimer() {
    remainingSeconds.value = 60;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        t.cancel();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
