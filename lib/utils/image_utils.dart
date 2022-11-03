import 'dart:convert';
import 'dart:typed_data';

class ImageUtils {
  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64StringFromData(Uint8List data) {
    return base64Encode(data);
  }

  static String removeExtensionFromFileName(String fullFileName) {
    return fullFileName.split('.').first;
  }
}
