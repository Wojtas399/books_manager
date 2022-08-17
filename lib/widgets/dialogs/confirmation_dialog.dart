import 'package:app/config/themes/app_colors.dart';
import 'package:app/widgets/buttons/small_red_button.dart';
import 'package:app/widgets/buttons/small_green_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  ConfirmationDialog({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HexColor(AppColors.LIGHT_BLUE),
      title: Text(title),
      content: Text(message),
      actions: [
        SmallRedButton(
          text: 'Nie',
          icon: Icons.close,
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        SmallGreenButton(
          text: 'Tak',
          icon: Icons.check,
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        SizedBox(width: 2),
      ],
    );
  }
}
