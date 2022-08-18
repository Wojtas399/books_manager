import 'package:flutter/cupertino.dart';

import 'app_colors.dart';

class GlobalCupertinoTheme {
  static CupertinoThemeData get lightTheme => CupertinoThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        textTheme: CupertinoTextThemeData(
          primaryColor: AppColors.black,
        ),
      );
}
