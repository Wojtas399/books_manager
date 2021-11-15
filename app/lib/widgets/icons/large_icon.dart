import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LargeIcon extends StatelessWidget {
  final IconData icon;
  final String? color;

  LargeIcon({required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    String? hexColor = color;
    return Icon(
      icon,
      color: hexColor != null ? HexColor(hexColor) : Colors.black87,
      size: 36,
    );
  }
}