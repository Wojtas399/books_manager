import 'package:flutter/widgets.dart';

abstract class WidgetFactory {
  Widget createApp({
    required String title,
    required Widget home,
  });

  Widget createScaffold({
    required Widget child,
    String? appBarTitle,
    bool withAppBar = true,
    Color? appBarBackgroundColor,
    bool appBarWithElevation = true,
    Icon? leadingIcon,
  });

  Widget createTextFormField({
    String? placeholder,
    Icon? icon,
    Color? backgroundColor,
    bool isPassword = false,
    bool isRequired = false,
    TextInputType? keyboardType,
    String? Function(String? value)? validator,
    Function(String)? onChanged,
  });

  Widget createButton({
    required String label,
    required VoidCallback? onPressed,
  });
}