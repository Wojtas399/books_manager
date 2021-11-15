import 'package:app/backend/book_service.dart';
import 'package:app/repositories/book_repository/book_interface.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/book_status_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookRepository implements BookInterface {
  late final BookService _bookService;
  late final BookCategoryService _bookCategoryService;
  late final BookStatusService _bookStatusService;

  BookRepository({
    required BookService bookService,
    required BookCategoryService bookCategoryService,
    required BookStatusService bookStatusService,
  }) {
    _bookService = bookService;
    _bookCategoryService = bookCategoryService;
    _bookStatusService = bookStatusService;
  }

  @override
  Stream<QuerySnapshot>? subscribeBooks() {
    return _bookService.subscribeBooks();
  }

  @override
  Future<String> getImgUrl(String imgPath) async {
    try {
      return await _bookService.getImgUrl(imgPath);
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  addNewBook({
    required String title,
    required String author,
    required BookCategory category,
    required String imgPath,
    required int readPages,
    required int pages,
    required BookStatus status,
  }) async {
    try {
      await _bookService.addBook(
        title: title,
        author: author,
        category: _bookCategoryService.convertCategoryToText(category),
        imgPath: imgPath,
        readPages: readPages,
        pages: pages,
        status: _bookStatusService.convertBookStatusToString(status),
      );
    } catch (error) {
      throw error;
    }
  }

  @override
  updateBookImage({
    required String bookId,
    required String newImgPath,
  }) async {
    try {
      await _bookService.updateBookImage(
        bookId: bookId,
        newImgPath: newImgPath,
      );
    } catch (error) {
      throw error;
    }
  }

  @override
  updateBook({
    required String bookId,
    String? author,
    String? title,
    BookCategory? category,
    int? pages,
    int? readPages,
    BookStatus? status,
  }) async {
    try {
      await _bookService.updateBook(
        bookId: bookId,
        author: author,
        title: title,
        category: category != null
            ? _bookCategoryService.convertCategoryToText(category)
            : null,
        pages: pages,
        readPages: readPages,
        status: status != null
            ? _bookStatusService.convertBookStatusToString(status)
            : null,
      );
    } catch (error) {
      throw error;
    }
  }

  @override
  deleteBook({required String bookId}) async {
    try {
      await _bookService.deleteBook(bookId: bookId);
    } catch (error) {
      throw error;
    }
  }
}
