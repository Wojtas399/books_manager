import 'package:flutter/material.dart';

import 'app_colors.dart';

class MaterialTextFieldTheme {
  static const UnderlineInputBorder _errorBorder = UnderlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.red),
  );

  static InputDecoration basic({
    IconData? iconData,
    String? label,
    String? placeholder,
    Color? backgroundColor,
    bool isPassword = false,
    bool isVisiblePassword = false,
    VoidCallback? onVisibilityIconPressed,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: placeholder,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 8,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.black.withOpacity(0.25),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: AppColors.primary),
      ),
      focusedErrorBorder: _errorBorder,
      errorBorder: _errorBorder,
      focusColor: AppColors.primary,
      errorMaxLines: 2,
      prefixIcon: Icon(iconData),
      prefixIconConstraints:
          iconData == null ? const BoxConstraints(maxWidth: 16) : null,
      suffixIcon: isPassword
          ? SizedBox(
              width: 50,
              child: IconButton(
                icon: Icon(
                  isVisiblePassword == false
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: onVisibilityIconPressed,
              ),
            )
          : null,
    );
  }
}
