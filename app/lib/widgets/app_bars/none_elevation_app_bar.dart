import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class NoneElevationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String text;
  final String? textColor;
  final String backgroundColor;
  final bool? centerTitle;

  NoneElevationAppBar({
    required this.text,
    required this.backgroundColor,
    this.textColor,
    this.centerTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: this.centerTitle,
      iconTheme: IconThemeData(
        color: HexColor(textColor ?? '#000000'),
      ),
      backgroundColor: HexColor(backgroundColor),
      title: Text(
        text,
        style: TextStyle(
          color: HexColor(textColor ?? '#000000'),
        ),
      ),
    );
  }
}
