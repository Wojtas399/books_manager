import 'package:flutter/widgets.dart';

class Utils {
  static void unfocusInputs() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static String twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
