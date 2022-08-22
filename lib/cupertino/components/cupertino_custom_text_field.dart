import 'package:flutter/cupertino.dart';

import '../../config/themes/app_colors.dart';
import '../../validators/validators_messages.dart';
import 'cupertino_text_field_background.dart';

class CupertinoCustomTextField extends StatelessWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final Function(String)? onChanged;

  const CupertinoCustomTextField({
    super.key,
    this.placeholder,
    this.icon,
    this.backgroundColor,
    this.isRequired = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTextFieldBackground(
      backgroundColor: backgroundColor,
      child: CupertinoTextFormFieldRow(
        placeholder: placeholder,
        prefix: icon,
        padding: const EdgeInsets.all(10),
        placeholderStyle: TextStyle(color: AppColors.grey),
        keyboardType: keyboardType,
        validator: _validate,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: onChanged,
      ),
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
