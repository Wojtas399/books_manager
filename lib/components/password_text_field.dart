import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../config/themes/material_text_field_theme.dart';
import '../validators/validator_messages.dart';

class PasswordTextField extends StatefulWidget {
  final String? label;
  final String? placeholder;
  final Color? backgroundColor;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const PasswordTextField({
    super.key,
    this.label,
    this.placeholder,
    this.backgroundColor,
    this.isRequired = false,
    this.keyboardType,
    this.validator,
    this.controller,
    this.onChanged,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !isVisible,
      obscuringCharacter: '*',
      decoration: MaterialTextFieldTheme.basic(
        iconData: MdiIcons.lock,
        label: widget.label,
        placeholder: widget.placeholder,
        isPassword: true,
        isVisiblePassword: isVisible,
        onVisibilityIconPressed: _onVisibilityIconPressed,
      ),
      keyboardType: widget.keyboardType,
      validator: _validate,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: widget.onChanged,
    );
  }

  void _onVisibilityIconPressed() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  String? _validate(String? value) {
    if (widget.isRequired && value == '') {
      return ValidatorMessages.requiredValue;
    }
    final String? Function(String? value)? customValidator = widget.validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
