import 'dart:typed_data';

import 'package:app/data/firebase/firebase_instances.dart';
import 'package:app/models/image.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageImageService {
  Future<void> saveImage({
    required Image image,
    required String userId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, image.fileName);
    await imageRef.putData(image.data);
  }

  Future<Uint8List?> loadImage({
    required String fileName,
    required String userId,
  }) async {
    _setMaximumDownloadingTime();
    final Reference imageRef = _getBookImageReference(userId, fileName);
    try {
      return await imageRef.getData();
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteImage({
    required String fileName,
    required String userId,
  }) async {
    final Reference imageRef = _getBookImageReference(userId, fileName);
    try {
      return await imageRef.delete();
    } catch (_) {}
  }

  Future<void> deleteAllUserImages({required String userId}) async {
    final Reference userDirectoryRef = _getUserDirectoryReference(userId);
    final ListResult files = await userDirectoryRef.listAll();
    for (final Reference fileRef in files.items) {
      await fileRef.delete();
    }
  }

  Reference _getBookImageReference(String userId, String fileName) {
    return FireInstances.storage.ref('$userId/$fileName');
  }

  Reference _getUserDirectoryReference(String userId) {
    return FireInstances.storage.ref(userId);
  }

  void _setMaximumDownloadingTime() {
    FireInstances.storage.setMaxDownloadRetryTime(
      const Duration(seconds: 10),
    );
  }
}
