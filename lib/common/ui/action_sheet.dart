import 'package:app/core/keys.dart';
import 'package:flutter/material.dart';

class ActionSheet {
  static showActionSheet(Widget widget) async {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      return await showModalBottomSheet(
        context: context,
        builder: (_) {
          return widget;
        },
      );
    }
  }
}