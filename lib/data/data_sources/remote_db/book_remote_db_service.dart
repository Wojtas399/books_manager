import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';

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

  Future<List<Book>> loadUserBooks({required String userId}) async {
    final List<FirebaseBook> firebaseBooks =
        await _firebaseFirestoreBookService.loadUserBooks(userId: userId);
    return await _convertFirebaseBooksToBooks(firebaseBooks);
  }

  Future<void> addBook({required Book book}) async {
    final Uint8List? imageData = book.imageData;
    await _firebaseFirestoreBookService.addBook(
      firebaseBook: _createFirebaseBook(book),
    );
    if (imageData != null) {
      await _firebaseStorageService.saveBookImageData(
        imageData: imageData,
        userId: book.userId,
        bookId: book.id,
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

  Future<List<Book>> _convertFirebaseBooksToBooks(
    List<FirebaseBook> firebaseBooks,
  ) async {
    final List<Book> books = [];
    for (final FirebaseBook firebaseBook in firebaseBooks) {
      final Uint8List? imageData =
          await _firebaseStorageService.loadBookImageData(
        userId: firebaseBook.userId,
        bookId: firebaseBook.id,
      );
      books.add(
        _createBook(firebaseBook, imageData),
      );
    }
    return books;
  }

  Book _createBook(FirebaseBook firebaseBook, Uint8List? imageData) {
    return Book(
      id: firebaseBook.id,
      userId: firebaseBook.userId,
      status: BookStatusMapper.mapFromStringToEnum(firebaseBook.status),
      imageData: imageData,
      title: firebaseBook.title,
      author: firebaseBook.author,
      readPagesAmount: firebaseBook.readPagesAmount,
      allPagesAmount: firebaseBook.allPagesAmount,
    );
  }

  FirebaseBook _createFirebaseBook(Book book) {
    return FirebaseBook(
      id: book.id,
      userId: book.userId,
      status: BookStatusMapper.mapFromEnumToString(book.status),
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    );
  }
}
