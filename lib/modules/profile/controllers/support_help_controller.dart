import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';

class SupportHelpController extends GetxController {
  final RxBool isLoading = false.obs;

  void openFaqs(BuildContext context) {
    context.push(AppRoutes.faq);
  }

  void reportProblem(BuildContext context) {
    context.push(AppRoutes.contactSupport);
  }

  void openPrivacyPolicy(BuildContext context) {
    context.push(AppRoutes.privacyPolicy);
  }

  void openTermsConditions(BuildContext context) {
    context.push(AppRoutes.termsConditions);
  }
}
