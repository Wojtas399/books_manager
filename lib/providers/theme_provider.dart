import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeProvider extends Cubit<ThemeMode> {
  ThemeProvider() : super(ThemeMode.light);

  bool isDarkModeOn(BuildContext context) {
    final ThemeMode themeMode = state;
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    return themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && brightness == Brightness.dark);
  }

  void turnOnLightTheme() {
    emit(ThemeMode.light);
  }

  void turnOnDarkTheme() {
    emit(ThemeMode.dark);
  }

  void turnOnSystemTheme() {
    emit(ThemeMode.system);
  }
}
