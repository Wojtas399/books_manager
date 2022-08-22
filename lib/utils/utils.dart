import 'package:flutter/widgets.dart';

class Utils {
  static void unfocusInputs() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}