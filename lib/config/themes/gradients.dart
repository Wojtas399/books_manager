import 'package:app/constants/theme.dart';
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