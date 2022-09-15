import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/models/db_book.dart';
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
    final List<DbBook> localDbBooks = await _bookLocalDbService.loadUserBooks(
      userId: userId,
      syncState: SyncState.none,
    );
    final List<DbBook> remoteDbBooks = await _bookRemoteDbService.loadUserBooks(
      userId: userId,
    );
    await _repairConsistencyOfBooks(localDbBooks, remoteDbBooks);
  }

  Future<void> synchronizeUserBooksMarkedAsAdded({
    required String userId,
  }) async {
    final List<DbBook> dbBooksMarkedAsAdded = await _bookLocalDbService
        .loadUserBooks(userId: userId, syncState: SyncState.added);
    for (final DbBook dbBook in dbBooksMarkedAsAdded) {
      await _bookRemoteDbService.addBook(dbBook: dbBook);
    }
    await _setDbBooksSyncStateToNone(dbBooksMarkedAsAdded);
  }

  Future<void> synchronizeUserBooksMarkedAsUpdated({
    required String userId,
  }) async {
    final List<DbBook> dbBooksMarkedAsUpdated = await _bookLocalDbService
        .loadUserBooks(userId: userId, syncState: SyncState.updated);
    for (final DbBook dbBook in dbBooksMarkedAsUpdated) {
      await _updateBookInRemoteDb(dbBook);
    }
    await _setDbBooksSyncStateToNone(dbBooksMarkedAsUpdated);
  }

  Future<void> synchronizeUserBooksMarkedAsDeleted({
    required String userId,
  }) async {
    final List<DbBook> dbBooksMarkedAsDeleted = await _bookLocalDbService
        .loadUserBooks(userId: userId, syncState: SyncState.deleted);
    final List<String> deletedDbBooksIds = _getIdsOfDbBooks(
      dbBooksMarkedAsDeleted,
    );
    await _deleteUserBooksFromBothDatabases(userId, deletedDbBooksIds);
  }

  Future<void> _repairConsistencyOfBooks(
    List<DbBook> localDbBooks,
    List<DbBook> remoteDbBooks,
  ) async {
    final List<String> localDbBooksIds = _getIdsOfDbBooks(localDbBooks);
    final List<String> remoteDbBooksIds = _getIdsOfDbBooks(remoteDbBooks);
    final List<String> uniqueDbBooksIds = ListUtils.getUniqueElementsFromLists(
      localDbBooksIds,
      remoteDbBooksIds,
    );
    for (final String dbBookId in uniqueDbBooksIds) {
      if (localDbBooksIds.contains(dbBookId)) {
        final DbBook localDbBook = localDbBooks.firstWhere(
          (DbBook dbBook) => dbBook.id == dbBookId,
        );
        await _makeLocalDbBookConsistentWithRemoteDbBooks(
          localDbBook,
          remoteDbBooks,
        );
      } else if (remoteDbBooksIds.contains(dbBookId)) {
        final DbBook remoteDbBook = remoteDbBooks.firstWhere(
          (DbBook dbBook) => dbBook.id == dbBookId,
        );
        await _bookLocalDbService.addBook(dbBook: remoteDbBook);
      }
    }
  }

  Future<void> _setDbBooksSyncStateToNone(List<DbBook> dbBooks) async {
    for (final DbBook dbBook in dbBooks) {
      await _bookLocalDbService.updateBookData(
        bookId: dbBook.id,
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

  List<String> _getIdsOfDbBooks(List<DbBook> dbBooks) {
    return dbBooks.map((DbBook dbBook) => dbBook.id).toList();
  }

  Future<void> _makeLocalDbBookConsistentWithRemoteDbBooks(
    DbBook localDbBook,
    List<DbBook> remoteDbBooks,
  ) async {
    final List<String> remoteDbBooksIds = _getIdsOfDbBooks(remoteDbBooks);
    if (remoteDbBooksIds.contains(localDbBook.id)) {
      final DbBook remoteDbBook = remoteDbBooks.firstWhere(
        (DbBook dbBook) => dbBook.id == localDbBook.id,
      );
      if (localDbBook != remoteDbBook) {
        await _updateBookInLocalDb(remoteDbBook);
      }
    } else {
      await _bookRemoteDbService.addBook(dbBook: localDbBook);
    }
  }

  Future<void> _updateBookInRemoteDb(DbBook dbBook) async {
    await _bookRemoteDbService.updateBookData(
      bookId: dbBook.id,
      userId: dbBook.userId,
      status: dbBook.status,
      title: dbBook.title,
      author: dbBook.author,
      readPagesAmount: dbBook.readPagesAmount,
      allPagesAmount: dbBook.allPagesAmount,
    );
    await _bookRemoteDbService.updateBookImage(
      bookId: dbBook.id,
      userId: dbBook.userId,
      imageData: dbBook.imageData,
    );
  }

  Future<void> _updateBookInLocalDb(DbBook dbBook) async {
    await _bookLocalDbService.updateBookData(
      bookId: dbBook.id,
      status: dbBook.status,
      title: dbBook.title,
      author: dbBook.author,
      readPagesAmount: dbBook.readPagesAmount,
      allPagesAmount: dbBook.allPagesAmount,
    );
    await _bookLocalDbService.updateBookImage(
      bookId: dbBook.id,
      userId: dbBook.userId,
      imageData: dbBook.imageData,
    );
  }
}
