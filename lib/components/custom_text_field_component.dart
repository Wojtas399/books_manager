import 'package:flutter/material.dart';

import '../config/themes/material_text_field_theme.dart';
import '../validators/validator_messages.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final IconData? iconData;
  final Color? backgroundColor;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.label,
    this.placeholder,
    this.iconData,
    this.backgroundColor,
    this.isRequired = false,
    this.keyboardType,
    this.validator,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: MaterialTextFieldTheme.underline(
        iconData: iconData,
        label: label,
        placeholder: placeholder,
        backgroundColor: backgroundColor,
      ),
      keyboardType: keyboardType,
      validator: _validate,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
    );
  }

  String? _validate(String? value) {
    if (isRequired && value == '') {
      return ValidatorMessages.requiredValue;
    }
    final String? Function(String? value)? customValidator = validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
