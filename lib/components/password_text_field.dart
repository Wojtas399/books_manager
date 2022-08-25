import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../config/themes/material_text_field_theme.dart';
import '../ui/validator_messages.dart';

class PasswordTextField extends StatefulWidget {
  final String? placeholder;
  final Color? backgroundColor;
  final bool isRequired;
  final String? Function(String? value)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const PasswordTextField({
    super.key,
    this.placeholder,
    this.backgroundColor,
    this.isRequired = false,
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
        icon: const Icon(MdiIcons.lock),
        placeholder: widget.placeholder,
        isPassword: true,
        isVisiblePassword: isVisible,
        onVisibilityIconPressed: _onVisibilityIconPressed,
      ),
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
