import 'package:flutter/material.dart';
import 'package:app/config/themes/button_theme.dart';

class BigGreenButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final IconData? icon;

  const BigGreenButton({
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    IconData? iconData = icon;
    if (iconData != null) {
      return ElevatedButton.icon(
        icon: Icon(iconData),
        onPressed: onPressed,
        label: Text(text),
        style: ButtonStyles.bigGreenButton(context: context),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
      style: ButtonStyles.bigGreenButton(context: context),
    );
  }
}
