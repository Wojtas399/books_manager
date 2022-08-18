import 'package:flutter/material.dart';

import '../../config/themes/material_text_field_theme.dart';
import 'material_text_field_background.dart';

class MaterialCustomTextField extends StatelessWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  const MaterialCustomTextField({
    super.key,
    this.placeholder,
    this.icon,
    this.backgroundColor,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialTextFieldBackground(
      backgroundColor: backgroundColor,
      child: TextFormField(
        decoration: MaterialTextFieldTheme.basic(
          icon: icon,
          placeholder: placeholder,
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }
}
