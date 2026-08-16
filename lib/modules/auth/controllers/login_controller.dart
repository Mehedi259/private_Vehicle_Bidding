import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_helper.dart';

class LoginController extends GetxController {
  // ─── Text Controllers ──────────────────────────────────────────────────────
  final TextEditingController emailController = TextEditingController(text: "mdshobuj204111@gmail.com");
  final TextEditingController passwordController = TextEditingController(text: "12_3456abc");

  // ─── Focus Nodes ──────────────────────────────────────────────────────────
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = true.obs;

  // ─── Form Key ─────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────────────────
  /// Toggles remember me state
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  /// Perform login action
  Future<void> login(BuildContext context) async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      // Mock network delay
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (context.mounted) {
        // Navigate to home after successful login
        context.go(AppRoutes.home);
        SnackbarHelper.showSuccess('Logged in successfully!');
      }
    } catch (e) {
      SnackbarHelper.showError('Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
