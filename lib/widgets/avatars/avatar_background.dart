import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app/constants/theme.dart';

class AvatarCircleShape extends StatelessWidget {
  final bool isSelected;
  final double size;
  final Widget child;

  AvatarCircleShape({
    required this.isSelected,
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
          color: HexColor(AppColors.DARK_GREEN),
          width: isSelected ? 4 : 2,
        ),
      ),
      child: child,
    );
  }
}
