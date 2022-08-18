import 'package:flutter/material.dart';

import '../components/material_custom_button.dart';
import '../components/material_custom_text_field.dart';
import '../components/material_password_text_field.dart';
import '../components/material_scaffold.dart';
import '../../config/themes/global_material_theme.dart';
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
  Widget createScaffold({
    required Widget child,
    bool withAppBar = true,
    String? appBarTitle,
    Color? appBarBackgroundColor,
    bool appBarWithElevation = true,
    Icon? leadingIcon,
  }) {
    return MaterialScaffold(
      withAppBar: withAppBar,
      appBarTitle: appBarTitle,
      appBarBackgroundColor: appBarBackgroundColor,
      appBarWithElevation: appBarWithElevation,
      leadingIcon: leadingIcon,
      child: child,
    );
  }

  @override
  Widget createTextFormField({
    String? placeholder,
    Icon? icon,
    Color? backgroundColor,
    bool isPassword = false,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    if (isPassword) {
      return MaterialPasswordTextField(
        placeholder: placeholder,
        icon: icon,
        backgroundColor: backgroundColor,
        onChanged: onChanged,
      );
    }
    return MaterialCustomTextField(
      placeholder: placeholder,
      icon: icon,
      backgroundColor: backgroundColor,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  @override
  Widget createButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return MaterialCustomButton(
      label: label,
      onPressed: onPressed,
    );
  }
}
