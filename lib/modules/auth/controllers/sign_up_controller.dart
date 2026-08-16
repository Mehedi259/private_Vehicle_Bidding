import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_helper.dart';
import 'dart:convert';
import '../../../../core/services/api_service.dart';
class SignUpController extends GetxController {
  // ─── Text Controllers ──────────────────────────────────────────────────────
  final TextEditingController emailController = TextEditingController(text: "mdshobuj204111@gmail.com");
  final TextEditingController fullNameController = TextEditingController(text: "Md Shobuj");
  final TextEditingController passwordController = TextEditingController(text: "12_3456abc");
  final TextEditingController confirmPasswordController = TextEditingController(text: "12_3456abc");

  // ─── Focus Nodes ──────────────────────────────────────────────────────────
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool acceptTerms = true.obs;

  // ─── Form Key ─────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onClose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    fullNameFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────────────────
  /// Toggles terms and conditions acceptance
  void toggleAcceptTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  /// Performs user sign up
  Future<void> createAccount(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    if (!acceptTerms.value) {
      SnackbarHelper.showError('You must accept the Terms and Conditions to proceed.');
      return;
    }

    isLoading.value = true;
    try {
      final response = await ApiService.post(
        '/accounts/user/register/',
        {
          'email': emailController.text.trim(),
          'name': fullNameController.text.trim(),
          'password': passwordController.text,
          'password2': confirmPasswordController.text,
        },
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          // Navigate to verification screen with email parameter
          context.go('${AppRoutes.verification}?email=${Uri.encodeComponent(emailController.text)}');
          SnackbarHelper.showSuccess('Account created successfully! Please verify your email.');
        }
      } else {
        final error = jsonDecode(response.body);
        SnackbarHelper.showError(error['message'] ?? 'Registration failed. Try again.');
      }
    } catch (e) {
      SnackbarHelper.showError('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigates to Login
  void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  /// Navigates to Terms and Conditions screen
  void showTermsAndConditions(BuildContext context) {
    context.push(AppRoutes.termsConditions);
  }
}
