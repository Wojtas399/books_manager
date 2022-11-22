import 'package:app/domain/entities/book.dart';
import 'package:app/models/image.dart';

abstract class BookInterface {
  void initializeBooksOfUser({required String userId});

  Stream<Book?> getBook({
    required String bookId,
    required String userId,
  });

  Stream<List<Book>?> getBooksOfUser({
    required String userId,
    BookStatus? bookStatus,
  });

  Future<void> addNewBook({
    required String userId,
    required BookStatus status,
    required Image? image,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  });

  Future<void> updateBook({
    required String bookId,
    required String userId,
    BookStatus? status,
    Image? image,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  });

  Future<void> deleteBookImage({
    required String bookId,
    required String userId,
  });

  Future<void> deleteBook({
    required String bookId,
    required String userId,
  });

  Future<void> deleteAllBooksOfUser({required String userId});

  void dispose();
}
