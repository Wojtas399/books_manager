import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'app_colors.dart';

class GlobalMaterialTheme {
  static ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: HexColor(AppColors.LIGHT_BLUE),
  );
}