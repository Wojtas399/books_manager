import 'package:flutter/cupertino.dart';

import '../config/themes/global_cupertino_theme.dart';
import '../interfaces/widget_factory.dart';

class CupertinoWidgetFactory implements WidgetFactory {
  Widget createApp({
    required String title,
    required Widget home,
  }) {
    return CupertinoApp(
      title: title,
      theme: GlobalCupertinoTheme.lightTheme,
      home: home,
    );
  }

  Widget createScaffold({required Widget child}) {
    return CupertinoPageScaffold(child: child);
  }
}
