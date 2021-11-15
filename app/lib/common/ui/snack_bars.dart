import 'package:app/core/keys.dart';
import 'package:flutter/material.dart';

class SnackBars {
  static showSnackBar(String message) {
    BuildContext? context = Keys.globalNavigatorKey.currentContext;
    if (context != null) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}