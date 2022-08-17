import 'package:flutter/widgets.dart';

abstract class WidgetFactoryInterface {
  Widget createApp({
    required String title,
    required Widget home,
  });

  Widget createScaffold({required Widget child});

  Widget createTextFormField({
    String? placeholder,
    Icon? icon,
    Color? backgroundColor,
    bool isPassword = false,
    TextInputType? keyboardType,
  });

  Widget createButton({
    required VoidCallback onPressed,
    required String text,
  });
}
