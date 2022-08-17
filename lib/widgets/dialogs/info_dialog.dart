import 'package:app/config/themes/button_theme.dart';
import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class InfoDialog extends StatelessWidget {
  final String header;
  final String message;

  InfoDialog({required this.header, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: HexColor(AppColors.LIGHT_BLUE),
      title: Text(header),
      content: SingleChildScrollView(child: Text(message)),
      actions: [
        ElevatedButton(
          child: Text('Zamknij'),
          style: ButtonStyles.smallGreenButton(context: context),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 2),
      ],
    );
  }
}
