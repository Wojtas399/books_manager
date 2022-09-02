import 'dart:io';

import '../models/device.dart';

class DeviceProvider {
  static Device provide() {
    if (Platform.isIOS || Platform.isAndroid) {
      return Smartphone();
    } else {
      throw UnimplementedError();
    }
  }
}
