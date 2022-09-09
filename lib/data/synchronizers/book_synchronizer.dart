import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/extensions/list_extensions.dart';
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
    final List<DbBook> localBooks =
        await _bookLocalDbService.loadUserBooks(userId: userId);
    final List<DbBook> remoteBooks =
        await _bookRemoteDbService.loadUserBooks(userId: userId);
    final List<DbBook> uniqueBooks =
        ListUtils.getUniqueElementsFromLists(localBooks, remoteBooks);
    await _addMissingBooksToDatabases(localBooks, remoteBooks, uniqueBooks);
  }

  Future<void> synchronizeUserBooksMarkedAsAdded({
    required String userId,
  }) async {
    final List<DbBook> dbBooksMarkedAsAdded =
        await _loadUserDbBooksMarkedAsAdded(userId);
    await _addBooksToRemoteDb(dbBooksMarkedAsAdded);
    await _setDbBooksSyncStateToNone(dbBooksMarkedAsAdded);
  }

  Future<void> synchronizeUserBooksMarkedAsUpdated({
    required String userId,
  }) async {
    final List<DbBook> dbBooksMarkedAsUpdated =
        await _loadUserDbBooksMarkedAsUpdated(userId);
    await _updateBooksInRemoteDb(dbBooksMarkedAsUpdated);
    await _setDbBooksSyncStateToNone(dbBooksMarkedAsUpdated);
  }

  Future<void> synchronizeUserBooksMarkedAsDeleted({
    required String userId,
  }) async {
    final List<String> deletedBooksIds =
        await _loadIdsOfUserBooksMarkedAsDeleted(userId);
    await _deleteUserBooksFromBothDatabases(userId, deletedBooksIds);
  }

  Future<List<DbBook>> _loadUserDbBooksMarkedAsAdded(String userId) async {
    return await _bookLocalDbService.loadUserBooks(
      userId: userId,
      syncState: SyncState.added,
    );
  }

  Future<List<DbBook>> _loadUserDbBooksMarkedAsUpdated(String userId) async {
    return await _bookLocalDbService.loadUserBooks(
      userId: userId,
      syncState: SyncState.updated,
    );
  }

  Future<List<String>> _loadIdsOfUserBooksMarkedAsDeleted(
    String userId,
  ) async {
    final List<DbBook> dbBooksMarkedAsDeleted = await _bookLocalDbService
        .loadUserBooks(userId: userId, syncState: SyncState.deleted);
    return dbBooksMarkedAsDeleted.map((DbBook dbBook) => dbBook.id).toList();
  }

  Future<void> _addMissingBooksToDatabases(
    List<DbBook> localBooks,
    List<DbBook> remoteBooks,
    List<DbBook> uniqueBooks,
  ) async {
    for (final DbBook dbBook in uniqueBooks) {
      if (localBooks.doesNotContain(dbBook)) {
        await _bookLocalDbService.addBook(dbBook: dbBook);
      }
      if (remoteBooks.doesNotContain(dbBook)) {
        await _bookRemoteDbService.addBook(dbBook: dbBook);
      }
    }
  }

  Future<void> _addBooksToRemoteDb(List<DbBook> booksToAdd) async {
    for (final DbBook dbBook in booksToAdd) {
      await _bookRemoteDbService.addBook(dbBook: dbBook);
    }
  }

  Future<void> _updateBooksInRemoteDb(List<DbBook> booksToUpdate) async {
    for (final DbBook dbBook in booksToUpdate) {
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
}
