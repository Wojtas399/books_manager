import 'package:app/domain/entities/book.dart';
import 'package:app/models/image_file.dart';

abstract class BookInterface {
  Stream<Book?> getBook({
    required String bookId,
    required String userId,
  });

  Stream<List<Book>> getUserBooks({
    required String userId,
    BookStatus? bookStatus,
  });

  Future<void> addNewBook({
    required String userId,
    required BookStatus status,
    required ImageFile? imageFile,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  });

  Future<void> updateBook({
    required String bookId,
    required String userId,
    BookStatus? status,
    ImageFile? imageFile,
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

  Future<void> deleteAllUserBooks({required String userId});
}
