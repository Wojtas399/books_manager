import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/models/db_book.dart';

class BookRemoteDbService {
  late final FirebaseFirestoreBookService _firebaseFirestoreBookService;
  late final FirebaseStorageService _firebaseStorageService;

  BookRemoteDbService({
    required FirebaseFirestoreBookService firebaseFirestoreBookService,
    required FirebaseStorageService firebaseStorageService,
  }) {
    _firebaseFirestoreBookService = firebaseFirestoreBookService;
    _firebaseStorageService = firebaseStorageService;
  }

  Future<List<DbBook>> loadUserBooks({required String userId}) async {
    final List<DbBook> dbBooksWithoutLoadedImages =
        await _firebaseFirestoreBookService.loadBooksByUserId(userId: userId);
    return await _loadImageForEachBook(dbBooksWithoutLoadedImages);
  }

  Future<void> addBook({required DbBook dbBook}) async {
    await _firebaseFirestoreBookService.addBook(dbBook: dbBook);
    final String? dbBookId = dbBook.id;
    final Uint8List? imageData = dbBook.imageData;
    if (imageData != null && dbBookId != null) {
      await _firebaseStorageService.saveBookImageData(
        imageData: imageData,
        userId: dbBook.userId,
        bookId: dbBookId,
      );
    }
  }

  Future<void> deleteBook({
    required String userId,
    required String bookId,
  }) async {
    await _firebaseFirestoreBookService.deleteBook(
      userId: userId,
      bookId: bookId,
    );
    await _firebaseStorageService.deleteBookImageData(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<List<DbBook>> _loadImageForEachBook(List<DbBook> dbBooks) async {
    final List<DbBook> dbBooksWithLoadedImages = [];
    for (final DbBook dbBook in dbBooks) {
      final DbBook dbBookWithLoadedImage = await _loadImageForBook(dbBook);
      dbBooksWithLoadedImages.add(dbBookWithLoadedImage);
    }
    return dbBooksWithLoadedImages;
  }

  Future<DbBook> _loadImageForBook(DbBook dbBook) async {
    final String? dbBookId = dbBook.id;
    Uint8List? imageData;
    if (dbBookId != null) {
      imageData = await _firebaseStorageService.loadBookImageData(
        userId: dbBook.userId,
        bookId: dbBookId,
      );
    }
    return dbBook.copyWith(imageData: imageData);
  }
}
