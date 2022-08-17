import 'package:flutter/material.dart';

import '../config/themes/global_material_theme.dart';
import '../interfaces/widget_factory.dart';

class MaterialWidgetFactory implements WidgetFactory {
  Widget createApp({
    required String title,
    required Widget home,
  }) {
    return MaterialApp(
      title: title,
      theme: GlobalMaterialTheme.lightTheme,
      home: home,
    );
  }

  Widget createScaffold({required Widget child}) {
    return Scaffold(body: child);
  }
}
