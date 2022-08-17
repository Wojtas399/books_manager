import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

import 'app_colors.dart';

class GlobalCupertinoTheme {
  static CupertinoThemeData get lightTheme => CupertinoThemeData(
        scaffoldBackgroundColor: HexColor(AppColors.LIGHT_BLUE),
      );
}
