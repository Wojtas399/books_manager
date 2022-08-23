import 'package:flutter/material.dart';

import '../../config/themes/material_text_field_theme.dart';
import '../../validators/validators_messages.dart';

class MaterialCustomTextField extends StatelessWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const MaterialCustomTextField({
    super.key,
    this.placeholder,
    this.icon,
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
      decoration: MaterialTextFieldTheme.basic(
        icon: icon,
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
      return ValidatorsMessages.requiredValueMessage;
    }
    final String? Function(String? value)? customValidator = validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
