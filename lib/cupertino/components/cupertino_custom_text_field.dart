import 'package:flutter/cupertino.dart';

import '../../config/themes/app_colors.dart';
import 'cupertino_text_field_background.dart';

class CupertinoCustomTextField extends StatelessWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  const CupertinoCustomTextField({
    super.key,
    this.placeholder,
    this.icon,
    this.backgroundColor,
    this.keyboardType,
    this.onChanged
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
        onChanged: onChanged,
      ),
    );
  }
}
