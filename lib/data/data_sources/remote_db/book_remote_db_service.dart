import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/mappers/book_mapper.dart';
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
    final List<FirebaseBook> firebaseBooks =
        await _firebaseFirestoreBookService.loadBooksByUserId(userId: userId);
    return await _convertFirebaseBooksToDbBooks(firebaseBooks);
  }

  Future<void> addBook({required DbBook dbBook}) async {
    final Uint8List? imageData = dbBook.imageData;
    await _firebaseFirestoreBookService.addBook(
      firebaseBook: BookMapper.mapFromDbModelToFirebaseModel(dbBook),
    );
    if (imageData != null) {
      await _firebaseStorageService.saveBookImageData(
        imageData: imageData,
        userId: dbBook.userId,
        bookId: dbBook.id,
      );
    }
  }

  Future<void> updateBookData({
    required String bookId,
    required String userId,
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) async {
    await _firebaseFirestoreBookService.updateBook(
      bookId: bookId,
      userId: userId,
      status: status,
      title: title,
      author: author,
      readPagesAmount: readPagesAmount,
      allPagesAmount: allPagesAmount,
    );
  }

  Future<void> updateBookImage({
    required String bookId,
    required String userId,
    required Uint8List? imageData,
  }) async {
    if (imageData == null) {
      await _firebaseStorageService.deleteBookImageData(
        userId: userId,
        bookId: bookId,
      );
    } else {
      await _firebaseStorageService.saveBookImageData(
        imageData: imageData,
        userId: userId,
        bookId: bookId,
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

  Future<void> deleteBookImage({
    required String userId,
    required String bookId,
  }) async {
    await _firebaseStorageService.deleteBookImageData(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<List<DbBook>> _convertFirebaseBooksToDbBooks(
    List<FirebaseBook> firebaseBooks,
  ) async {
    final List<DbBook> dbBooks = [];
    for (final FirebaseBook firebaseBook in firebaseBooks) {
      final Uint8List? imageData =
          await _firebaseStorageService.loadBookImageData(
        userId: firebaseBook.userId,
        bookId: firebaseBook.id,
      );
      dbBooks.add(
        BookMapper.mapFromFirebaseModelToDbModel(firebaseBook, imageData),
      );
    }
    return dbBooks;
  }
}
