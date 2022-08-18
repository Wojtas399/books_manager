import 'package:flutter/widgets.dart';

abstract class WidgetFactoryInterface {
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
    TextInputType? keyboardType,
    Function(String)? onChanged,
  });

  Widget createButton({
    required String label,
    required VoidCallback? onPressed,
  });
}
