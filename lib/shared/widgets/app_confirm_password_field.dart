import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import 'app_text_field.dart';

class AppConfirmPasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final TextEditingController passwordController;
  final String labelText;
  final String hintText;

  const AppConfirmPasswordField({
    super.key,
    this.controller,
    required this.passwordController,
    this.labelText = 'Confirm Password',
    this.hintText = '••••••••••',
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      validator: (value) => Validators.validateConfirmPassword(value, passwordController.text),
    );
  }
}
