import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/firebase_instances.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  Future<void> saveBookImageData({
    required Uint8List imageData,
    required String bookId,
    required String userId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, bookId);
    await imageRef.putData(imageData);
  }

  Future<Uint8List?> loadBookImageData({
    required String bookId,
    required String userId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, bookId);
    try {
      return await imageRef.getData();
    } catch (_) {
      return null;
    }
  }

  Reference _getBookImageReference(String userId, String bookId) {
    return FireInstances.storage.ref('$userId/books/$bookId.jpg');
  }
}
