import 'package:app/config/themes/text_field_theme.dart';
import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  final String label;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  PasswordTextFormField({
    required this.label,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState(
        label: label,
        onChanged: onChanged,
        validator: validator,
        controller: controller,
      );
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isObscure = true;
  final String label;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  _PasswordTextFormFieldState({
    required this.label,
    this.onChanged,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: _isObscure,
      cursorColor: Colors.black,
      onChanged: onChanged,
      decoration: TextFieldTheme.passwordTheme(
        label: label,
        onClickVisibilityIcon: () {
          onPressedIcon();
        },
        isVisiblePassword: _isObscure,
      ),
      validator: validator ?? null,
      controller: controller,
    );
  }

  void onPressedIcon() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
}
