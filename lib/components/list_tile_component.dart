import 'package:flutter/material.dart';

class ListTileComponent extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color? color;
  final bool boldText;
  final Widget? trailing;
  final VoidCallback? onPressed;

  const ListTileComponent({
    super.key,
    required this.title,
    required this.iconData,
    this.color,
    this.boldText = false,
    this.trailing,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    FontWeight? fontWeight;
    if (boldText) {
      fontWeight = FontWeight.w500;
    }

    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: fontWeight),
      ),
      leading: Icon(
        iconData,
        color: color,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      trailing: trailing,
      onTap: onPressed,
    );
  }
}
