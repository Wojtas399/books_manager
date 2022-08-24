import 'package:flutter/material.dart';

import 'app_colors.dart';

class GlobalMaterialTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.black,
          centerTitle: true,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: 0.15,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.secondary,
          unselectedItemColor: Colors.black.withOpacity(0.3),
          selectedItemColor: Colors.black,
        ),
      );
}
