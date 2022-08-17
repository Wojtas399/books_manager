import 'package:flutter/cupertino.dart';

import '../../components/cupertino_password_text_field.dart';
import '../../components/cupertino_text_field_background.dart';
import '../../config/themes/app_colors.dart';
import '../../config/themes/global_cupertino_theme.dart';
import '../../interfaces/factories/widget_factory_interface.dart';

class CupertinoWidgetFactory implements WidgetFactoryInterface {
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
  Widget createScaffold({required Widget child}) {
    return CupertinoPageScaffold(child: child);
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
      return CupertinoPasswordTextField(
        placeholder: placeholder,
        icon: icon,
        backgroundColor: backgroundColor,
        onChanged: onChanged,
      );
    }
    return CupertinoTextFieldBackground(
      backgroundColor: backgroundColor,
      child: CupertinoTextFormFieldRow(
        placeholder: placeholder,
        prefix: icon,
        padding: const EdgeInsets.all(10),
        placeholderStyle: TextStyle(color: AppColors.grey),
        keyboardType: keyboardType,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget createButton({
    required VoidCallback? onPressed,
    required String text,
  }) {
    return SizedBox(
      width: 280,
      child: CupertinoButton(
        onPressed: onPressed,
        color: AppColors.darkGreen,
        child: Text(text),
      ),
    );
  }
}
