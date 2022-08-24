import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class GlobalMaterialTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: _colorScheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        appBarTheme: _appBarTheme,
        bottomNavigationBarTheme: _bottomNavigationBarTheme,
      );

  static final ColorScheme _colorScheme = const ColorScheme.light().copyWith(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
  );

  static final AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.black,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      letterSpacing: 0.15,
    ),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  static final BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.secondary,
    unselectedItemColor: Colors.black.withOpacity(0.3),
    selectedItemColor: Colors.black,
  );
}
