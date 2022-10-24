import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/id_generator.dart';
import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/models/device.dart';
import 'package:app/models/repository.dart';

class BookRepository extends Repository<Book> implements BookInterface {
  late final BookSynchronizer _bookSynchronizer;
  late final BookLocalDbService _bookLocalDbService;
  late final BookRemoteDbService _bookRemoteDbService;
  late final Device _device;
  late final IdGenerator _idGenerator;

  BookRepository({
    required BookSynchronizer bookSynchronizer,
    required BookLocalDbService bookLocalDbService,
    required BookRemoteDbService bookRemoteDbService,
    required Device device,
    required IdGenerator idGenerator,
    final List<Book>? books,
  }) {
    _bookSynchronizer = bookSynchronizer;
    _bookLocalDbService = bookLocalDbService;
    _bookRemoteDbService = bookRemoteDbService;
    _device = device;
    _idGenerator = idGenerator;

    if (books != null) {
      addEntities(books);
    }
  }

  @override
  Future<void> initializeForUser({required String userId}) async {
    if (await _device.hasInternetConnection()) {
      // await _bookSynchronizer.synchronizeUserBooksMarkedAsDeleted(
      //   userId: userId,
      // );
      // await _bookSynchronizer.synchronizeUserBooksMarkedAsAdded(userId: userId);
      // await _bookSynchronizer.synchronizeUserBooksMarkedAsUpdated(
      //   userId: userId,
      // );
      // await _bookSynchronizer.synchronizeUnmodifiedUserBooks(userId: userId);
    }
  }

  @override
  Stream<Book?> getBookById({required String bookId}) {
    return const Stream.empty();
    // return stream.map(
    //   (List<Book>? books) {
    //     if (books == null) {
    //       return null;
    //     }
    //     final List<Book?> allBooks = [...books];
    //     return allBooks.firstWhere(
    //       (Book? book) => book?.id == bookId,
    //       orElse: () => null,
    //     );
    //   },
    // ).whereType<Book>();
  }

  @override
  Stream<List<Book>?> getBooksByUserId({required String userId}) {
    return Stream.value([]);
    // return stream.map(
    //   (List<Book>? books) {
    //     return books?.where((Book book) => book.belongsTo(userId)).toList();
    //   },
    // );
  }

  @override
  Future<void> loadUserBooks({
    required String userId,
    BookStatus? bookStatus,
  }) async {
    // final List<Book> books = await _bookLocalDbService.loadUserBooks(
    //   userId: userId,
    //   bookStatus: bookStatus?.name,
    // );
    // addEntities(books);
  }

  @override
  Future<void> addNewBook({
    required String userId,
    required BookStatus status,
    required Uint8List? imageData,
    required String title,
    required String author,
    required int readPagesAmount,
    required int allPagesAmount,
  }) async {
    // final Book book = Book(
    //   id: _idGenerator.generateRandomId(),
    //   imageData: imageData,
    //   userId: userId,
    //   status: status,
    //   title: title,
    //   author: author,
    //   readPagesAmount: readPagesAmount,
    //   allPagesAmount: allPagesAmount,
    // );
    // SyncState syncState = SyncState.added;
    // if (await _device.hasInternetConnection()) {
    //   await _bookRemoteDbService.addBook(book: book);
    //   syncState = SyncState.none;
    // }
    // await _bookLocalDbService.addBook(book: book, syncState: syncState);
    // addEntity(book);
  }

  @override
  Future<void> updateBookData({
    required String bookId,
    BookStatus? bookStatus,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) async {
    // final String? userId = _getIdOfUserAssignedToBook(bookId);
    // SyncState syncState = SyncState.updated;
    // if (userId == null) {
    //   return;
    // }
    // if (await _device.hasInternetConnection()) {
    //   await _bookRemoteDbService.updateBookData(
    //     bookId: bookId,
    //     userId: userId,
    //     status: bookStatus?.name,
    //     title: title,
    //     author: author,
    //     readPagesAmount: readPagesAmount,
    //     allPagesAmount: allPagesAmount,
    //   );
    //   syncState = SyncState.none;
    // }
    // final Book updatedBook = await _bookLocalDbService.updateBookData(
    //   bookId: bookId,
    //   status: bookStatus?.name,
    //   title: title,
    //   author: author,
    //   readPagesAmount: readPagesAmount,
    //   allPagesAmount: allPagesAmount,
    //   syncState: syncState,
    // );
    // updateEntity(updatedBook);
  }

  @override
  Future<void> updateBookImage({
    required String bookId,
    required Uint8List? imageData,
  }) async {
    // final String? userId = _getIdOfUserAssignedToBook(bookId);
    // SyncState? newSyncState;
    // if (userId == null) {
    //   return;
    // }
    // if (await _device.hasInternetConnection()) {
    //   await _bookRemoteDbService.updateBookImage(
    //     bookId: bookId,
    //     userId: userId,
    //     imageData: imageData,
    //   );
    // } else {
    //   newSyncState = SyncState.updated;
    // }
    // Book updatedBook = await _bookLocalDbService.updateBookImage(
    //   bookId: bookId,
    //   userId: userId,
    //   imageData: imageData,
    // );
    // if (newSyncState != null) {
    //   updatedBook = await _bookLocalDbService.updateBookData(
    //     bookId: bookId,
    //     syncState: newSyncState,
    //   );
    // }
    // updateEntity(updatedBook);
  }

  @override
  Future<void> deleteBook({required String bookId}) async {
    // final String? userId = _getIdOfUserAssignedToBook(bookId);
    // if (userId != null && await _device.hasInternetConnection()) {
    //   await _bookRemoteDbService.deleteBook(userId: userId, bookId: bookId);
    //   await _bookLocalDbService.deleteBook(userId: userId, bookId: bookId);
    // } else {
    //   await _bookLocalDbService.updateBookData(
    //     bookId: bookId,
    //     syncState: SyncState.deleted,
    //   );
    // }
    // removeEntity(bookId);
  }

  @override
  Future<void> deleteAllUserBooks({required String userId}) async {
    // final List<Book> userBooks = await _bookLocalDbService.loadUserBooks(
    //   userId: userId,
    // );
    // if (await _device.hasInternetConnection()) {
    //   await _deleteEachBookFromBothDatabases(userBooks);
    // } else {
    //   await _markEachBookAsDeletedInLocalDb(userBooks);
    // }
  }

  String? _getIdOfUserAssignedToBook(String bookId) {
    return value?.firstWhere((Book book) => book.id == bookId).userId;
  }

  Future<void> _deleteEachBookFromBothDatabases(
    List<Book> booksToDelete,
  ) async {
    for (final Book book in booksToDelete) {
      await _bookRemoteDbService.deleteBook(
        userId: book.userId,
        bookId: book.id,
      );
      await _bookLocalDbService.deleteBook(
        userId: book.userId,
        bookId: book.id,
      );
    }
  }

  Future<void> _markEachBookAsDeletedInLocalDb(
    List<Book> booksToMark,
  ) async {
    for (final Book book in booksToMark) {
      await _bookLocalDbService.updateBookData(
        bookId: book.id,
        syncState: SyncState.deleted,
      );
    }
  }
}
