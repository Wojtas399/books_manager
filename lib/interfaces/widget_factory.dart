import 'package:flutter/material.dart';

abstract class WidgetFactory {
  Widget createApp({
    required String title,
    required Widget home,
  });

  Widget createScaffold({required Widget child});
}
