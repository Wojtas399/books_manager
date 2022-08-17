import 'package:flutter/material.dart';

import '../interfaces/widget_factory.dart';

class MaterialWidgetFactory implements WidgetFactory {
  Widget createApp({
    required String title,
    required Widget home,
  }) {
    return MaterialApp(
      title: title,
      home: home,
    );
  }

  Widget createScaffold({
    required Widget child,
    String? appBarTitle,
  }) {
    return Scaffold(
      body: child,
      appBar: AppBar(
        title: Text(appBarTitle ?? ''),
      ),
    );
  }
}
