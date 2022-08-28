import 'package:rxdart/rxdart.dart';

import '../../database/sqlite/entities/sqlite_book.dart';
import '../../database/sqlite/services/sqlite_book_service.dart';
import '../../interfaces/book_interface.dart';
import '../../utils/utils.dart';
import '../entities/book.dart';

class BookRepository implements BookInterface {
  late final SqliteBookService _sqliteBookService;
  final BehaviorSubject<List<Book>> _books$ =
      BehaviorSubject<List<Book>>.seeded([]);

  BookRepository({
    required SqliteBookService sqliteBookService,
  }) {
    _sqliteBookService = sqliteBookService;
  }

  @override
  Stream<List<Book>> getBooksByUserId({required String userId}) =>
      _books$.stream.map(
        (List<Book> books) => books
            .where(
              (Book book) => book.userId == userId,
            )
            .toList(),
      );

  @override
  Future<void> loadAllBooksByUserId({required String userId}) async {
    final List<SqliteBook> sqliteBooks =
        await _sqliteBookService.loadBooksByUserId(userId: userId);
    final List<Book> books = sqliteBooks.map(_convertSqliteBookToBook).toList();
    _books$.add(books);
  }

  @override
  Future<void> addNewBook({required Book book}) async {
    final SqliteBook sqliteBook = await _sqliteBookService.addNewBook(
      _convertBookToSqliteBook(book),
    );
    _addNewBookToList(_convertSqliteBookToBook(sqliteBook));
  }

  SqliteBook _convertBookToSqliteBook(Book book) {
    return SqliteBook(
      image: Utils.base64String(book.imageData),
      userId: book.userId,
      status: book.status.name,
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    );
  }

  Book _convertSqliteBookToBook(SqliteBook sqliteBook) {
    return Book(
      userId: sqliteBook.userId,
      status: _convertStringToBookStatus(sqliteBook.status),
      imageData: Utils.dataFromBase64String(sqliteBook.image),
      title: sqliteBook.title,
      author: sqliteBook.author,
      readPagesAmount: sqliteBook.readPagesAmount,
      allPagesAmount: sqliteBook.allPagesAmount,
    );
  }

  BookStatus _convertStringToBookStatus(String bookStatusAsString) {
    switch (bookStatusAsString) {
      case 'unread':
        return BookStatus.unread;
      case 'inProgress':
        return BookStatus.inProgress;
      case 'finished':
        return BookStatus.finished;
      default:
        throw 'Cannot convert book status';
    }
  }

  void _addNewBookToList(Book book) {
    final List<Book> updatedCollection = [..._books$.value];
    updatedCollection.add(book);
    _books$.add(updatedCollection);
  }
}
