import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/utils/snackbar_helper.dart';
import 'dart:convert';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/shared_prefs_service.dart';

class LoginController extends GetxController {
  // ─── Text Controllers ──────────────────────────────────────────────────────
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
      final response = await ApiService.post(
        '/accounts/user/login/',
        {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
        requireAuth: false,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final access = data['token']['access'];
        final refresh = data['token']['refresh'];

        await SharedPrefsService.saveTokens(access: access, refresh: refresh);
        
        // Optionally save user info if it returns
        // await SharedPrefsService.saveUser(email: emailController.text.trim());

        if (context.mounted) {
          context.go(AppRoutes.home);
          SnackbarHelper.showSuccess('Logged in successfully!');
        }
      } else {
        final error = jsonDecode(response.body);
        SnackbarHelper.showError(error['message'] ?? 'Login failed. Invalid credentials.');
      }
    } catch (e) {
      SnackbarHelper.showError('Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
