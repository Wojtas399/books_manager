import 'package:flutter/material.dart';

import '../../config/themes/app_colors.dart';

class MaterialTextFieldBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const MaterialTextFieldBackground({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
