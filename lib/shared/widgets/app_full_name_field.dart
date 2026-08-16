import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import 'app_text_field.dart';

class AppFullNameField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;

  const AppFullNameField({
    super.key,
    this.controller,
    this.labelText = 'Full Name',
    this.hintText = 'Bonnie Green',
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.name,
      validator: Validators.validateFullName,
    );
  }
}
