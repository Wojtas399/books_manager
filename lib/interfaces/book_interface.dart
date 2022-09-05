import 'package:app/domain/entities/book.dart';

abstract class BookInterface {
  Future<void> refreshUserBooks({required String userId});

  Stream<Book> getBookById({required String bookId});

  Stream<List<Book>> getBooksByUserId({required String userId});

  Future<void> loadAllBooksByUserId({required String userId});

  Future<void> addNewBook({required Book book});

  Future<void> deleteBook({
    required String userId,
    required String bookId,
  });

  void reset();
}
