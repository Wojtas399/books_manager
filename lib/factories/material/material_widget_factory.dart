import 'package:flutter/material.dart';

import '../../components/material_password_text_field.dart';
import '../../components/material_text_field_background.dart';
import '../../config/themes/global_material_theme.dart';
import '../../config/themes/material_text_field_theme.dart';
import '../../interfaces/factories/widget_factory_interface.dart';

class MaterialWidgetFactory implements WidgetFactoryInterface {
  @override
  Widget createApp({
    required String title,
    required Widget home,
  }) {
    return MaterialApp(
      title: title,
      theme: GlobalMaterialTheme.lightTheme,
      home: home,
    );
  }

  @override
  Widget createScaffold({required Widget child}) {
    return Scaffold(body: child);
  }

  @override
  Widget createTextFormField({
    String? placeholder,
    Icon? icon,
    Color? backgroundColor,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    if (isPassword) {
      return MaterialPasswordTextField(
        placeholder: placeholder,
        icon: icon,
        backgroundColor: backgroundColor,
      );
    }
    return MaterialTextFieldBackground(
      backgroundColor: backgroundColor,
      child: TextFormField(
        decoration: MaterialTextFieldTheme.basic(
          icon: icon,
          placeholder: placeholder,
        ),
        keyboardType: keyboardType,
      ),
    );
  }

  @override
  Widget createButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return SizedBox(
      width: 280,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
