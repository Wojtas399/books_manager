import 'package:flutter/cupertino.dart';

import 'app_colors.dart';

class GlobalCupertinoTheme {
  static CupertinoThemeData get lightTheme => CupertinoThemeData(
        scaffoldBackgroundColor: AppColors.lightBlue,
        primaryColor: AppColors.green,
      );
}
