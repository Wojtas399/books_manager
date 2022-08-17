import 'package:flutter/material.dart';

import 'app_colors.dart';

class MaterialTextFieldTheme {
  static InputDecoration basic({
    Icon? icon,
    String? placeholder,
    bool isPassword = false,
    bool isVisiblePassword = false,
    VoidCallback? onVisibilityIconPressed,
  }) {
    return InputDecoration(
      hintText: placeholder,
      prefixIcon: icon,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 4,
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: AppColors.darkGreen,
        ),
      ),
      focusColor: AppColors.darkGreen,
      errorMaxLines: 2,
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
