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
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      focusColor: AppColors.primary,
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
