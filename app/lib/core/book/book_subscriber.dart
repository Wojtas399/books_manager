import 'dart:async';
import 'package:app/core/book/book_bloc.dart';
import 'package:app/repositories/book_repository/book_interface.dart';
import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/book_status_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class BookSubscriber {
  late BookInterface _bookInterface;
  late BookBloc _bookBloc;
  late BehaviorSubject<List<Book>> _books;
  StreamSubscription? _booksSubscription;
  BookStatusService _bookStatusService = BookStatusService();
  BookCategoryService _bookCategoryService = BookCategoryService();

  BookSubscriber({
    required BehaviorSubject<List<Book>> books,
    required BookInterface bookInterface,
    required BookBloc bookBloc,
  }) {
    _books = books;
    _bookInterface = bookInterface;
    _bookBloc = bookBloc;
  }

  subscribeBooks() {
    Stream<QuerySnapshot>? snapshot = _bookInterface.subscribeBooks();
    if (snapshot != null) {
      _booksSubscription = snapshot.listen((event) {
        event.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            print('added book');
            _addNewBook(change.doc);
          }
          if (change.type == DocumentChangeType.modified) {
            print('modified book');
            _updateModifiedBook(change.doc);
          }
          if (change.type == DocumentChangeType.removed) {
            print('removed');
            _removeBook(change.doc);
          }
        });
      });
    }
  }

  unsubscribeBooks() {
    _booksSubscription?.cancel();
  }

  _addNewBook(DocumentSnapshot book) async {
    Map<String, dynamic> bookData = book.data() as Map<String, dynamic>;
    List<Book> allBooks = _books.value;
    allBooks.add(await _getAddedBookData(book.id, bookData));
    _books.add(allBooks);
  }

  _updateModifiedBook(DocumentSnapshot book) async {
    Map<String, dynamic> bookData = book.data() as Map<String, dynamic>;
    List<Book> allBooks = _books.value;
    int index = allBooks.indexWhere((elem) => elem.id == book.id);
    Book currentBook = allBooks[index];
    allBooks[index] = await _getUpdatedBookData(currentBook, bookData);
    _books.add(allBooks);
  }

  _removeBook(DocumentSnapshot book) async {
    List<Book> allBooks = _books.value;
    allBooks.removeWhere((elem) => elem.id == book.id);
    _books.add(allBooks);
  }

  Future<Book> _getAddedBookData(
    bookId,
    Map<String, dynamic> bookData,
  ) async {
    return new Book(
      id: bookId,
      author: bookData['author'],
      title: bookData['title'],
      category: _bookCategoryService.convertTextToCategory(
        bookData['category'],
      ),
      pages: bookData['pages'],
      readPages: bookData['readPages'],
      status: _bookStatusService.convertStringToBookStatus(bookData['status']),
      imgPath: bookData['imgPath'],
      imgUrl: await _bookBloc.getImgUrl(bookData['imgPath']),
      addDate: bookData['addDate'],
      lastActualisation: bookData['lastActualisation'],
    );
  }

  Future<Book> _getUpdatedBookData(
    Book currentBook,
    Map<String, dynamic> newBookData,
  ) async {
    String author = currentBook.author;
    String title = currentBook.title;
    BookCategory category = currentBook.category;
    int pages = currentBook.pages;
    int readPages = currentBook.readPages;
    BookStatus status = currentBook.status;
    String imgPath = currentBook.imgPath;
    String imgUrl = currentBook.imgUrl;
    String addDate = currentBook.addDate;
    String lastActualisation = currentBook.lastActualisation;
    if (newBookData['author'] != author) {
      author = newBookData['author'];
    }
    if (newBookData['title'] != title) {
      title = newBookData['title'];
    }
    if (newBookData['category'] != category) {
      category = _bookCategoryService.convertTextToCategory(
        newBookData['category'],
      );
    }
    if (newBookData['pages'] != pages) {
      pages = newBookData['pages'];
    }
    if (newBookData['readPages'] != readPages) {
      readPages = newBookData['readPages'];
    }
    BookStatus newStatus = _bookStatusService.convertStringToBookStatus(
      newBookData['status'],
    );
    if (newStatus != status) {
      status = newStatus;
    }
    if (newBookData['imgPath'] != imgPath) {
      imgPath = newBookData['imgPath'];
      imgUrl = await _bookBloc.getImgUrl(imgPath);
    }
    if (newBookData['addDate'] != addDate) {
      addDate = newBookData['addDate'];
    }
    if (newBookData['lastActualisation'] != lastActualisation) {
      lastActualisation = newBookData['lastActualisation'];
    }
    return new Book(
      id: currentBook.id,
      author: author,
      title: title,
      category: category,
      pages: pages,
      readPages: readPages,
      status: status,
      imgPath: imgPath,
      imgUrl: imgUrl,
      addDate: addDate,
      lastActualisation: lastActualisation,
    );
  }
}
