import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

class GlobalMaterialTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: const ColorScheme.light().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.primary,
        ),
        elevatedButtonTheme: _MaterialTheme.elevatedButtonTheme,
        appBarTheme: _MaterialTheme.appBarTheme,
      );

  static ThemeData get darkTheme => ThemeData(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.primary,
        ),
        elevatedButtonTheme: _MaterialTheme.elevatedButtonTheme,
        appBarTheme: _MaterialTheme.appBarTheme,
        bottomNavigationBarTheme: _MaterialThemeDark.bottomNavigationBarTheme,
      );
}

class _MaterialTheme {
  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    ),
  );

  static const AppBarTheme appBarTheme = AppBarTheme(
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}

class _MaterialThemeDark {
  static final BottomNavigationBarThemeData bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkSurface,
  );
}
