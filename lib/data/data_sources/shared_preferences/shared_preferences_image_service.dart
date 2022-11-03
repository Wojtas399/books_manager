import 'dart:typed_data';

import 'package:app/utils/image_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesImageService {
  Future<void> saveImage({
    required String imageFileName,
    required Uint8List imageData,
  }) async {
    final SharedPreferences prefs = await _getSharedPreferencesInstance();
    final String imageDataInBase64 = ImageUtils.base64StringFromData(imageData);
    await prefs.setString(imageFileName, imageDataInBase64);
  }

  Future<Uint8List?> loadImage({required String imageFileName}) async {
    final SharedPreferences prefs = await _getSharedPreferencesInstance();
    final String? imageDataInBase64Str = prefs.getString(imageFileName);
    if (imageDataInBase64Str == null) {
      return null;
    }
    return ImageUtils.dataFromBase64String(imageDataInBase64Str);
  }

  Future<void> deleteImage({required String imageFileName}) async {
    final SharedPreferences prefs = await _getSharedPreferencesInstance();
    await prefs.remove(imageFileName);
  }

  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }
}
