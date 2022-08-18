import 'package:flutter/cupertino.dart';

import '../../config/themes/app_colors.dart';

class CupertinoCustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CupertinoCustomButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: CupertinoButton(
        onPressed: onPressed,
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        child: Text(label),
      ),
    );
  }
}
