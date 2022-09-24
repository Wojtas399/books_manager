import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class Utils {
  static void unfocusInputs() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static Uint8List? dataFromBase64String(String? base64String) {
    if (base64String == null) {
      return null;
    }
    return base64Decode(base64String);
  }

  static String? base64String(Uint8List? data) {
    if (data == null) {
      return null;
    }
    return base64Encode(data);
  }

  static String twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }
}
