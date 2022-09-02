import 'package:app/domain/entities/book.dart';

abstract class BookInterface {
  Stream<List<Book>> getBooksByUserId({required String userId});

  Future<void> refreshUserBooks({required String userId});

  Future<void> loadAllBooksByUserId({required String userId});

  Future<void> addNewBook({required Book book});

  void reset();
}
