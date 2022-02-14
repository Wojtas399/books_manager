import 'package:app/core/book/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BookInterface {
  Stream<QuerySnapshot>? subscribeBooks();

  Future<String> getImgUrl(String imgPath);

  addNewBook({
    required String title,
    required String author,
    required BookCategory category,
    required String imgPath,
    required int readPages,
    required int pages,
    required BookStatus status,
  });

  updateBookImage({
    required String bookId,
    required String newImgPath,
  });

  updateBook({
    required String bookId,
    String? author,
    String? title,
    BookCategory? category,
    int? pages,
    int? readPages,
    BookStatus? status,
  });

  deleteBook({required String bookId});
}
