import 'dart:typed_data';

import 'package:app/data/data_sources/firebase/firebase_instances.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<void> saveBookImageData({
    required Uint8List imageData,
    required String fileName,
    required String userId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, fileName);
    await imageRef.putData(imageData);
  }

  Future<Uint8List?> loadBookImageData({
    required String fileName,
    required String userId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, fileName);
    try {
      return await imageRef.getData();
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteBookImageData({
    required String fileName,
    required String userId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, fileName);
    try {
      return await imageRef.delete();
    } catch (_) {}
  }

  Reference _getBookImageReference(String userId, String fileName) {
    final List<String> dividedFileName = fileName.split('.');
    final String fileNameWithoutExtension = dividedFileName.first;
    return FireInstances.storage.ref('$userId/$fileNameWithoutExtension.jpg');
  }
}
