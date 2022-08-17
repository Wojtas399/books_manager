import 'package:flutter/cupertino.dart';

import '../config/themes/app_colors.dart';

class CupertinoTextFieldBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const CupertinoTextFieldBackground({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
