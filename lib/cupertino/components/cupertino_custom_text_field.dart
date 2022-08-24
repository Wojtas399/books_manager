import 'package:flutter/cupertino.dart';

import '../../config/themes/app_colors.dart';
import '../../ui/errors_messages.dart';
import 'cupertino_text_field_background.dart';

class CupertinoCustomTextField extends StatelessWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CupertinoCustomTextField({
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
    return CupertinoTextFieldBackground(
      backgroundColor: backgroundColor,
      child: CupertinoTextFormFieldRow(
        style: const TextStyle(color: CupertinoColors.black),
        placeholder: placeholder,
        prefix: icon,
        padding: const EdgeInsets.all(8),
        placeholderStyle: TextStyle(color: AppColors.grey),
        keyboardType: keyboardType,
        validator: _validate,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
      ),
    );
  }

  String? _validate(String? value) {
    if (isRequired && value == '') {
      return ErrorsMessages.requiredValue;
    }
    final String? Function(String? value)? customValidator = validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
