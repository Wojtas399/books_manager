import 'dart:io';
import 'dart:typed_data';

import 'package:sqflite/sqflite.dart';

class LocalStorageService {
  Future<void> saveBookImageData({
    required Uint8List imageData,
    required String userId,
    required String bookId,
  }) async {
    final File imageFile = await _createFile(userId, bookId);
    await imageFile.writeAsBytes(imageData);
  }

  Future<Uint8List?> loadBookImageData({
    required String userId,
    required String bookId,
  }) async {
    final File imageFile = await _createFile(userId, bookId);
    if (!await imageFile.exists()) {
      return null;
    }
    return await imageFile.readAsBytes();
  }

  Future<void> deleteBookImageData({
    required String userId,
    required String bookId,
  }) async {
    final File imageFile = await _createFile(userId, bookId);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }

  Future<File> _createFile(String userId, String bookId) async {
    final String filePath = await _createFilePath(bookId, userId);
    return File(filePath);
  }

  Future<String> _createFilePath(String userId, String bookId) async {
    final String databasePath = await getDatabasesPath();
    return '$databasePath/$userId-$bookId.jpg';
  }
}
