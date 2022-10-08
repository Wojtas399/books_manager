import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/utils/list_utils.dart';

class BookSynchronizer {
  late final BookLocalDbService _bookLocalDbService;
  late final BookRemoteDbService _bookRemoteDbService;

  BookSynchronizer({
    required BookLocalDbService bookLocalDbService,
    required BookRemoteDbService bookRemoteDbService,
  }) {
    _bookLocalDbService = bookLocalDbService;
    _bookRemoteDbService = bookRemoteDbService;
  }

  Future<void> synchronizeUnmodifiedUserBooks({
    required String userId,
  }) async {
    final List<Book> localBooks = await _bookLocalDbService.loadUserBooks(
      userId: userId,
      syncState: SyncState.none,
    );
    final List<Book> remoteBooks = await _bookRemoteDbService.loadUserBooks(
      userId: userId,
    );
    await _repairConsistencyOfBooks(localBooks, remoteBooks);
  }

  Future<void> synchronizeUserBooksMarkedAsAdded({
    required String userId,
  }) async {
    final List<Book> booksMarkedAsAdded = await _bookLocalDbService
        .loadUserBooks(userId: userId, syncState: SyncState.added);
    for (final Book book in booksMarkedAsAdded) {
      await _bookRemoteDbService.addBook(book: book);
    }
    await _setBooksSyncStateToNone(booksMarkedAsAdded);
  }

  Future<void> synchronizeUserBooksMarkedAsUpdated({
    required String userId,
  }) async {
    final List<Book> booksMarkedAsUpdated = await _bookLocalDbService
        .loadUserBooks(userId: userId, syncState: SyncState.updated);
    for (final Book book in booksMarkedAsUpdated) {
      await _updateBookInRemoteDb(book);
    }
    await _setBooksSyncStateToNone(booksMarkedAsUpdated);
  }

  Future<void> synchronizeUserBooksMarkedAsDeleted({
    required String userId,
  }) async {
    final List<Book> booksMarkedAsDeleted = await _bookLocalDbService
        .loadUserBooks(userId: userId, syncState: SyncState.deleted);
    final List<String> deletedBooksIds = _getIdsOfBooks(
      booksMarkedAsDeleted,
    );
    await _deleteUserBooksFromBothDatabases(userId, deletedBooksIds);
  }

  Future<void> _repairConsistencyOfBooks(
    List<Book> localBooks,
    List<Book> remoteBooks,
  ) async {
    final List<String> localBooksIds = _getIdsOfBooks(localBooks);
    final List<String> remoteBooksIds = _getIdsOfBooks(remoteBooks);
    final List<String> uniqueBooksIds = ListUtils.getUniqueElementsFromLists(
      localBooksIds,
      remoteBooksIds,
    );
    for (final String bookId in uniqueBooksIds) {
      if (localBooksIds.contains(bookId)) {
        final Book localBook = localBooks.firstWhere(
          (Book book) => book.id == bookId,
        );
        await _makeLocalBookConsistentWithRemoteBooks(localBook, remoteBooks);
      } else if (remoteBooksIds.contains(bookId)) {
        final Book remoteBook = remoteBooks.firstWhere(
          (Book book) => book.id == bookId,
        );
        await _bookLocalDbService.addBook(book: remoteBook);
      }
    }
  }

  Future<void> _setBooksSyncStateToNone(List<Book> books) async {
    for (final Book book in books) {
      await _bookLocalDbService.updateBookData(
        bookId: book.id,
        syncState: SyncState.none,
      );
    }
  }

  Future<void> _deleteUserBooksFromBothDatabases(
    String userId,
    List<String> idsOfBooksToDelete,
  ) async {
    for (final String bookId in idsOfBooksToDelete) {
      await _bookRemoteDbService.deleteBook(
        userId: userId,
        bookId: bookId,
      );
      await _bookLocalDbService.deleteBook(
        userId: userId,
        bookId: bookId,
      );
    }
  }

  List<String> _getIdsOfBooks(List<Book> books) {
    return books.map((Book book) => book.id).toList();
  }

  Future<void> _makeLocalBookConsistentWithRemoteBooks(
    Book localBook,
    List<Book> remoteBooks,
  ) async {
    final List<String> remoteBooksIds = _getIdsOfBooks(remoteBooks);
    if (remoteBooksIds.contains(localBook.id)) {
      final Book remoteBook = remoteBooks.firstWhere(
        (Book book) => book.id == localBook.id,
      );
      if (localBook != remoteBook) {
        await _updateBookInLocalDb(remoteBook);
      }
    } else {
      await _bookLocalDbService.deleteBook(
        bookId: localBook.id,
        userId: localBook.userId,
      );
    }
  }

  Future<void> _updateBookInRemoteDb(Book book) async {
    await _bookRemoteDbService.updateBookData(
      bookId: book.id,
      userId: book.userId,
      status: BookStatusMapper.mapFromEnumToString(book.status),
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    );
    await _bookRemoteDbService.updateBookImage(
      bookId: book.id,
      userId: book.userId,
      imageData: book.imageData,
    );
  }

  Future<void> _updateBookInLocalDb(Book book) async {
    await _bookLocalDbService.updateBookData(
      bookId: book.id,
      status: BookStatusMapper.mapFromEnumToString(book.status),
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    );
    await _bookLocalDbService.updateBookImage(
      bookId: book.id,
      userId: book.userId,
      imageData: book.imageData,
    );
  }
}
