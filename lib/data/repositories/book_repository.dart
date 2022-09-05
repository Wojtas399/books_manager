import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/mappers/book_mapper.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/extensions/book_extensions.dart';
import 'package:app/interfaces/book_interface.dart';
import 'package:app/models/device.dart';
import 'package:rxdart/rxdart.dart';

class BookRepository implements BookInterface {
  late final BookSynchronizer _bookSynchronizer;
  late final BookLocalDbService _bookLocalDbService;
  late final BookRemoteDbService _bookRemoteDbService;
  late final Device _device;
  final BehaviorSubject<List<Book>> _books$ =
      BehaviorSubject<List<Book>>.seeded([]);

  BookRepository({
    required BookSynchronizer bookSynchronizer,
    required BookLocalDbService bookLocalDbService,
    required BookRemoteDbService bookRemoteDbService,
    required Device device,
  }) {
    _bookSynchronizer = bookSynchronizer;
    _bookLocalDbService = bookLocalDbService;
    _bookRemoteDbService = bookRemoteDbService;
    _device = device;
  }

  Stream<List<Book>> get _booksStream$ => _books$.stream;

  @override
  Future<void> refreshUserBooks({required String userId}) async {
    if (await _device.hasInternetConnection()) {
      await _bookSynchronizer.deleteUserBooksMarkedAsDeleted(userId: userId);
      await _bookSynchronizer.synchronizeUserBooks(userId: userId);
    }
  }

  @override
  Stream<Book> getBookById({required String bookId}) {
    return _booksStream$.map(
      (List<Book> books) {
        final List<Book?> allBooks = [...books];
        return allBooks.firstWhere(
          (Book? book) => book?.id == bookId,
          orElse: () => null,
        );
      },
    ).whereType<Book>();
  }

  @override
  Stream<List<Book>> getBooksByUserId({required String userId}) {
    return _booksStream$.map(
      (List<Book> books) {
        return books.where((Book book) => book.belongsTo(userId)).toList();
      },
    );
  }

  @override
  Future<void> loadAllBooksByUserId({required String userId}) async {
    final List<DbBook> dbBooks =
        await _bookLocalDbService.loadUserBooks(userId: userId);
    final List<Book> books =
        dbBooks.map(BookMapper.mapFromDbModelToEntity).toList();
    _books$.add(books);
  }

  @override
  Future<void> addNewBook({required Book book}) async {
    final DbBook dbBook = await _bookLocalDbService.addBook(
      dbBook: BookMapper.mapFromEntityToDbModel(book),
    );
    if (await _device.hasInternetConnection()) {
      await _bookRemoteDbService.addBook(dbBook: dbBook);
    }
    final Book newBook = BookMapper.mapFromDbModelToEntity(dbBook);
    _addNewBookToList(newBook);
  }

  @override
  Future<void> deleteBook({
    required String userId,
    required String bookId,
  }) async {
    if (await _device.hasInternetConnection()) {
      await _bookRemoteDbService.deleteBook(userId: userId, bookId: bookId);
      await _bookLocalDbService.deleteBook(userId: userId, bookId: bookId);
    } else {
      await _bookLocalDbService.markBookAsDeleted(bookId: bookId);
    }
    _removeBookFromList(bookId);
  }

  @override
  void reset() {
    _books$.add([]);
  }

  void _addNewBookToList(Book book) {
    final List<Book> updatedCollection = [..._books$.value];
    updatedCollection.add(book);
    _books$.add(updatedCollection);
  }

  void _removeBookFromList(String bookId) {
    final List<Book> updatedCollection = [..._books$.value];
    updatedCollection.removeWhere((Book book) => book.id == bookId);
    _books$.add(updatedCollection);
  }
}
