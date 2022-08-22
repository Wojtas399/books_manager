import 'package:flutter/widgets.dart';

import 'app_colors.dart';

class TextTheme {
  static TextStyle titleBig = const TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
  );

  static TextStyle titleMedium = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle greyText = TextStyle(
    fontSize: 16,
    color: AppColors.black.withOpacity(0.5),
  );
}
