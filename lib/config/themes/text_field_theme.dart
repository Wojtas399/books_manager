import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/config/themes/app_colors.dart';

class TextFieldTheme {
  static InputDecoration basicTheme({
    required String label,
    String? placeholder,
  }) {
    return _theme(
      label: label,
      placeholder: placeholder,
      isPassword: false,
    );
  }

  static InputDecoration passwordTheme({
    required String label,
    required VoidCallback onClickVisibilityIcon,
    required bool isVisiblePassword,
  }) {
    return _theme(
      label: label,
      isPassword: true,
      onClickVisibilityIcon: onClickVisibilityIcon,
      isVisiblePassword: isVisiblePassword,
    );
  }

  static InputDecoration _theme({
    required String label,
    required bool isPassword,
    String? placeholder,
    VoidCallback? onClickVisibilityIcon,
    bool? isVisiblePassword,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.black,
      ),
      hintText: placeholder,
      contentPadding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: HexColor(AppColors.DARK_GREEN),
        ),
      ),
      errorMaxLines: 2,
      focusColor: HexColor(AppColors.DARK_GREEN),
      prefixIconConstraints: BoxConstraints(minWidth: 40),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                isVisiblePassword != null && isVisiblePassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: HexColor(AppColors.DARK_GREEN),
              ),
              onPressed: onClickVisibilityIcon,
            )
          : null,
    );
  }
}
