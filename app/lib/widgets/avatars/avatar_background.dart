import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/constants/theme.dart';

class AvatarBackground extends StatelessWidget {
  final bool isChosen;
  final double size;
  final Widget child;

  AvatarBackground({
    required this.isChosen,
    required this.child,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
            color: HexColor(AppColors.DARK_GREEN), width: isChosen ? 4 : 2),
      ),
      child: child,
    );
  }
}
