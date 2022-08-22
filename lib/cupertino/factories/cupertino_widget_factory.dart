import 'package:flutter/cupertino.dart';

import '../components/cupertino_custom_button.dart';
import '../components/cupertino_custom_text_field.dart';
import '../components/cupertino_password_text_field.dart';
import '../components/cupertino_scaffold.dart';
import '../../config/themes/global_cupertino_theme.dart';
import '../../interfaces/factories/widget_factory.dart';

class CupertinoWidgetFactory implements WidgetFactory {
  @override
  Widget createApp({
    required String title,
    required Widget home,
  }) {
    return CupertinoApp(
      title: title,
      theme: GlobalCupertinoTheme.lightTheme,
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
    bool automaticallyImplyLeading = true,
  }) {
    return CupertinoScaffold(
      withAppBar: withAppBar,
      appBarTitle: appBarTitle,
      appBarBackgroundColor: appBarBackgroundColor,
      appBarWithElevation: appBarWithElevation,
      leadingIcon: leadingIcon,
      automaticallyImplyLeading: automaticallyImplyLeading,
      child: child,
    );
  }

  @override
  Widget createTextFormField({
    String? placeholder,
    Icon? icon,
    Color? backgroundColor,
    bool isPassword = false,
    bool isRequired = false,
    TextInputType? keyboardType,
    String? Function(String? value)? validator,
    Function(String)? onChanged,
  }) {
    if (isPassword) {
      return CupertinoPasswordTextField(
        placeholder: placeholder,
        icon: icon,
        backgroundColor: backgroundColor,
        isRequired: isRequired,
        validator: validator,
        onChanged: onChanged,
      );
    }
    return CupertinoCustomTextField(
      placeholder: placeholder,
      icon: icon,
      backgroundColor: backgroundColor,
      isRequired: isRequired,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
    );
  }

  @override
  Widget createButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return CupertinoCustomButton(
      label: label,
      onPressed: onPressed,
    );
  }
}
