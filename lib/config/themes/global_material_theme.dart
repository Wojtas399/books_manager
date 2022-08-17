import 'package:flutter/material.dart';

import 'app_colors.dart';

class GlobalMaterialTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.lightBlue,
        colorScheme: const ColorScheme.light().copyWith(
          primary: AppColors.darkGreen,
          secondary: AppColors.lightBlue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            ),
          ),
        ),
      );
}
