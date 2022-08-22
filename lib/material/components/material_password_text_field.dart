import 'package:flutter/material.dart';

import '../../config/themes/material_text_field_theme.dart';
import '../../validators/validators_messages.dart';

class MaterialPasswordTextField extends StatefulWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;
  final bool isRequired;
  final String? Function(String? value)? validator;
  final Function(String)? onChanged;

  const MaterialPasswordTextField({
    super.key,
    this.placeholder,
    this.icon,
    this.backgroundColor,
    this.isRequired = false,
    this.validator,
    this.onChanged,
  });

  @override
  State<MaterialPasswordTextField> createState() =>
      _MaterialPasswordTextFieldState();
}

class _MaterialPasswordTextFieldState extends State<MaterialPasswordTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !isVisible,
      obscuringCharacter: '*',
      decoration: MaterialTextFieldTheme.basic(
        icon: widget.icon,
        placeholder: widget.placeholder,
        isPassword: true,
        isVisiblePassword: isVisible,
        onVisibilityIconPressed: _onVisibilityIconPressed,
      ),
      validator: _validate,
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
      return ValidatorsMessages.requiredValueMessage;
    }
    final String? Function(String? value)? customValidator = widget.validator;
    if (customValidator != null) {
      return customValidator(value);
    }
    return null;
  }
}
