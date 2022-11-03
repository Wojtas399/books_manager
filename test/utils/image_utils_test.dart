import 'dart:convert';
import 'dart:typed_data';

import 'package:app/utils/image_utils.dart';
import 'package:test/test.dart';

void main() {
  test(
    'data from base 64 string, should convert base 64 string to Uint8List type',
    () {
      final Uint8List expectedData = Uint8List(10);
      final String base64String = base64Encode(expectedData);

      final Uint8List data = ImageUtils.dataFromBase64String(base64String);

      expect(data, expectedData);
    },
  );

  test(
    'base 64 string from data, should convert Uint8List type to base 64 string',
    () {
      final Uint8List data = Uint8List(10);
      final String expectedBase64String = base64Encode(data);

      final String base64String = ImageUtils.base64StringFromData(data);

      expect(base64String, expectedBase64String);
    },
  );

  test(
    'remove extension from file name, should remove extensions from the end of file name',
    () {
      const String fullFileName = 'XYZ.jpg';
      const String expectedFileName = 'XYZ';

      final String fileName =
          ImageUtils.removeExtensionFromFileName(fullFileName);

      expect(fileName, expectedFileName);
    },
  );
}
