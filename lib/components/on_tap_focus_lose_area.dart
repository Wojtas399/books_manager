import 'package:flutter/widgets.dart';

import '../config/themes/app_colors.dart';

class OnTapFocusLoseArea extends StatelessWidget {
  final Widget child;

  const OnTapFocusLoseArea({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _unfocusElements(),
      child: Container(
        color: AppColors.transparent,
        child: child,
      ),
    );
  }

  void _unfocusElements() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}