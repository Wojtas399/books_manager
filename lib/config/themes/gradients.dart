import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

class Gradients {
  static LinearGradient greenBlueGradient() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        HexColor(AppColors.DARK_BLUE),
        HexColor(AppColors.LIGHT_GREEN),
      ],
    );
  }
}