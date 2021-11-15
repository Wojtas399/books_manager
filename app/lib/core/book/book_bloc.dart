import 'dart:async';
import 'package:app/repositories/book_repository/book_interface.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/book/book_subscriber.dart';
import 'package:rxdart/rxdart.dart';

class BookBloc {
  late final BookSubscriber _bookSubscriber;
  late final BookInterface _bookInterface;

  BookBloc({required BookInterface bookInterface}) {
    _bookInterface = bookInterface;
    _bookSubscriber = BookSubscriber(
      books: _books,
      bookInterface: _bookInterface,
      bookBloc: this,
    );
  }

  BehaviorSubject<List<Book>> _books =
      new BehaviorSubject<List<Book>>.seeded([]);

  Stream<List<Book>> get allBooks$ => _books.stream;

  subscribeBooks() {
    _bookSubscriber.subscribeBooks();
  }

  Future<String> getImgUrl(String imgPath) async {
    return await _bookInterface.getImgUrl(imgPath);
  }

  addNewBook({
    required String title,
    required String author,
    required BookCategory category,
    required String imgPath,
    required int readPages,
    required int pages,
    required BookStatus status,
  }) async {
    await _bookInterface.addNewBook(
      title: title,
      author: author,
      category: category,
      imgPath: imgPath,
      readPages: readPages,
      pages: pages,
      status: status,
    );
  }

  updateBookImg({
    required String bookId,
    required String newImgPath,
  }) async {
    await _bookInterface.updateBookImage(
      bookId: bookId,
      newImgPath: newImgPath,
    );
  }

  updateBook({
    required String bookId,
    String? author,
    String? title,
    BookCategory? category,
    int? pages,
    int? readPages,
    BookStatus? status,
  }) async {
    await _bookInterface.updateBook(
      bookId: bookId,
      author: author,
      title: title,
      category: category != null ? category : null,
      pages: pages,
      readPages: readPages,
      status: status != null ? status : null,
    );
  }

  deleteBook({required String bookId}) async {
    await _bookInterface.deleteBook(bookId: bookId);
  }

  dispose() {
    print('Called DISPOSE BOOK BLOC');
    _bookSubscriber.unsubscribeBooks();
    _books.close();
  }
}
