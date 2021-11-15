import 'package:flutter/material.dart';
import 'package:app/config/themes/text_field_theme.dart';

class BasicTextFormField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final String? initialValue;
  final TextInputType? type;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  BasicTextFormField({
    required this.label,
    this.onChanged,
    this.placeholder,
    this.initialValue,
    this.type,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: Colors.black,
      onChanged: onChanged,
      decoration: TextFieldTheme.basicTheme(
        label: label,
        placeholder: placeholder,
      ),
      validator: validator ?? null,
      controller: controller,
    );
  }
}
