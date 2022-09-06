import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/firebase_instances.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<void> saveBookImageData({
    required Uint8List imageData,
    required String userId,
    required String bookId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, bookId);
    await imageRef.putData(imageData);
  }

  Future<Uint8List?> loadBookImageData({
    required String userId,
    required String bookId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, bookId);
    try {
      return await imageRef.getData();
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteBookImageData({
    required String userId,
    required String bookId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, bookId);
    try {
      return await imageRef.delete();
    } catch (_) {}
  }

  Reference _getBookImageReference(String userId, String bookId) {
    return FireInstances.storage.ref('$userId/$bookId.jpg');
  }
}
