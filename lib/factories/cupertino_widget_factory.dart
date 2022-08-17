import 'package:flutter/cupertino.dart';

import '../interfaces/widget_factory.dart';

class CupertinoWidgetFactory implements WidgetFactory {
  Widget createApp({
    required String title,
    required Widget home,
  }) {
    return CupertinoApp(
      title: title,
      home: home,
    );
  }

  Widget createScaffold({
    required Widget child,
    String? appBarTitle,
  }) {
    return CupertinoPageScaffold(
      child: child,
      navigationBar: CupertinoNavigationBar(
        middle: Text(appBarTitle ?? ''),
      ),
    );
  }
}
