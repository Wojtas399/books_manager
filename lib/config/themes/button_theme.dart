import 'package:app/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ButtonStyles {
  static ButtonStyle smallGreenButton({
    required BuildContext context,
  }) {
    return ButtonStyles.smallButton(
      color: AppColors.DARK_GREEN,
      context: context,
    );
  }

  static ButtonStyle smallRedButton({
    required BuildContext context,
  }) {
    return ButtonStyles.smallButton(
      color: AppColors.RED,
      context: context,
    );
  }

  static ButtonStyle mediumGreenButton({
    required BuildContext context,
  }) {
    return ButtonStyles.mediumButton(
      color: AppColors.DARK_GREEN,
      context: context,
    );
  }

  static ButtonStyle mediumRedButton({
    required BuildContext context,
  }) {
    return ButtonStyles.mediumButton(
      color: AppColors.RED,
      context: context,
    );
  }

  static ButtonStyle bigGreenButton({
    required BuildContext context,
  }) {
    return ButtonStyles.bigButton(
      color: AppColors.DARK_GREEN,
      context: context,
    );
  }

  static ButtonStyle smallButton({
    required String color,
    required BuildContext context,
  }) {
    return ElevatedButton.styleFrom(
      primary: HexColor(color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: Theme.of(context).textTheme.button,
    );
  }

  static ButtonStyle mediumButton({
    required String color,
    required BuildContext context,
  }) {
    return ElevatedButton.styleFrom(
      primary: HexColor(color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      minimumSize: Size(120, 40),
      textStyle: Theme.of(context).textTheme.button,
    );
  }

  static ButtonStyle bigButton({
    required String color,
    required BuildContext context,
  }) {
    return ElevatedButton.styleFrom(
      primary: HexColor(color),
      minimumSize: Size(200, 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: Theme.of(context).textTheme.button,
    );
  }
}
