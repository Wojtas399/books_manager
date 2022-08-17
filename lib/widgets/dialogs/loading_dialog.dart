import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/config/themes/app_colors.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      backgroundColor: HexColor(AppColors.LIGHT_BLUE),
      content: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: HexColor(AppColors.DARK_GREEN),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Ładowanie...',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}