import 'dart:io';
import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';

class LocalStorageService {
  Future<void> saveBookImageData({
    required Uint8List imageData,
    required String bookId,
    required String userId,
  }) async {
    final File imageFile = await _createFile(bookId, userId);
    await imageFile.writeAsBytes(imageData);
  }

  Future<Uint8List?> loadBookImageData({
    required String bookId,
    required String userId,
  }) async {
    final File imageFile = await _createFile(bookId, userId);
    if (!await imageFile.exists()) {
      return null;
    }
    return await imageFile.readAsBytes();
  }

  Future<File> _createFile(String bookId, String userId) async {
    final String filePath = await _createFilePath(bookId, userId);
    return File(filePath);
  }

  Future<String> _createFilePath(String bookId, String userId) async {
    final String databasePath = await getDatabasesPath();
    return '$databasePath/$userId-$bookId.jpg';
  }
}
