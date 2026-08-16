import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import 'app_text_field.dart';

class AppPasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;

  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText = 'Password',
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
      validator: Validators.validatePassword,
    );
  }
}
