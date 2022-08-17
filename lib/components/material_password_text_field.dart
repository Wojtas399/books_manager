import 'package:flutter/material.dart';

import '../config/themes/material_text_field_theme.dart';
import 'material_text_field_background.dart';

class MaterialPasswordTextField extends StatefulWidget {
  final String? placeholder;
  final Icon? icon;
  final Color? backgroundColor;

  const MaterialPasswordTextField({
    super.key,
    this.placeholder,
    this.icon,
    this.backgroundColor,
  });

  @override
  State<MaterialPasswordTextField> createState() =>
      _MaterialPasswordTextFieldState();
}

class _MaterialPasswordTextFieldState extends State<MaterialPasswordTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return MaterialTextFieldBackground(
      backgroundColor: widget.backgroundColor,
      child: TextFormField(
        obscureText: !isVisible,
        obscuringCharacter: '*',
        decoration: MaterialTextFieldTheme.basic(
          icon: widget.icon,
          placeholder: widget.placeholder,
          isPassword: true,
          isVisiblePassword: isVisible,
          onVisibilityIconPressed: _onVisibilityIconPressed,
        ),
      ),
    );
  }

  void _onVisibilityIconPressed() {
    setState(() {
      isVisible = !isVisible;
    });
  }
}
