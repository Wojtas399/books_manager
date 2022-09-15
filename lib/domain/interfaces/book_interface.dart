import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';

abstract class BookInterface {
  Future<void> refreshUserBooks({required String userId});

  Stream<Book> getBookById({required String bookId});

  Stream<List<Book>> getBooksByUserId({required String userId});

  Future<void> loadAllBooksByUserId({required String userId});

  Future<void> addNewBook({
    required String userId,
    required BookStatus status,
    required Uint8List? imageData,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  });

  Future<void> updateBookData({
    required String bookId,
    required String userId,
    BookStatus? bookStatus,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  });

  Future<void> updateBookImage({
    required String bookId,
    required String userId,
    required Uint8List? imageData,
  });

  Future<void> deleteBook({
    required String userId,
    required String bookId,
  });

  void reset();
}
