import 'package:rxdart/rxdart.dart';

import '../../database/entities/db_book.dart';
import '../../database/firebase/services/fire_book_service.dart';
import '../../database/sqlite/services/sqlite_book_service.dart';
import '../../interfaces/book_interface.dart';
import '../../models/device.dart';
import '../../utils/utils.dart';
import '../entities/book.dart';

class BookRepository implements BookInterface {
  late final SqliteBookService _sqliteBookService;
  late final FirebaseBookService _firebaseBookService;
  late final Device _device;
  final BehaviorSubject<List<Book>> _books$ =
      BehaviorSubject<List<Book>>.seeded([]);

  BookRepository({
    required SqliteBookService sqliteBookService,
    required FirebaseBookService firebaseBookService,
    required Device device,
  }) {
    _sqliteBookService = sqliteBookService;
    _firebaseBookService = firebaseBookService;
    _device = device;
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
    final List<DbBook> dbBooks =
        await _sqliteBookService.loadBooksByUserId(userId: userId);
    final List<Book> books = dbBooks.map(_convertDatabaseBookToBook).toList();
    _books$.add(books);
  }

  @override
  Future<void> addNewBook({required Book book}) async {
    final DbBook dbBook = await _sqliteBookService.addNewBook(
      _convertBookToDatabaseBook(book),
    );
    if (await _device.hasInternetConnection()) {
      await _firebaseBookService.addNewBook(dbBook);
    }
    _addNewBookToList(_convertDatabaseBookToBook(dbBook));
  }

  DbBook _convertBookToDatabaseBook(Book book) {
    return DbBook(
      image: Utils.base64String(book.imageData),
      userId: book.userId,
      status: book.status.name,
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    );
  }

  Book _convertDatabaseBookToBook(DbBook dbBook) {
    return Book(
      id: dbBook.id,
      userId: dbBook.userId,
      status: _convertStringToBookStatus(dbBook.status),
      imageData: Utils.dataFromBase64String(dbBook.image),
      title: dbBook.title,
      author: dbBook.author,
      readPagesAmount: dbBook.readPagesAmount,
      allPagesAmount: dbBook.allPagesAmount,
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
