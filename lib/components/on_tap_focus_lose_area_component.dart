import 'package:flutter/widgets.dart';

import '../config/themes/app_colors.dart';
import '../utils/utils.dart';

class OnTapFocusLoseAreaComponent extends StatelessWidget {
  final Widget child;

  const OnTapFocusLoseAreaComponent({
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
    Utils.unfocusInputs();
  }
}