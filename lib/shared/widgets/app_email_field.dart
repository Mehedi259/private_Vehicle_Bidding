import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import 'app_text_field.dart';

class AppEmailField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;

  const AppEmailField({
    super.key,
    this.controller,
    this.labelText = 'Email',
    this.hintText = 'name@example.com',
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
    );
  }
}
