import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
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

  Future<void> deleteUserBooksMarkedAsDeleted({
    required String userId,
  }) async {
    final List<String> deletedBooksIds =
        await _bookLocalDbService.loadIdsOfUserBooksMarkedAsDeleted(
      userId: userId,
    );
    await _deleteUserBooksFromDatabases(userId, deletedBooksIds);
  }

  Future<void> synchronizeUserBooks({required String userId}) async {
    final List<DbBook> localBooks =
        await _bookLocalDbService.loadUserBooks(userId: userId);
    final List<DbBook> remoteBooks =
        await _bookRemoteDbService.loadUserBooks(userId: userId);
    final List<DbBook> uniqueBooks = ListUtils.getUniqueElementsFromLists(
      localBooks,
      remoteBooks,
    );
    await _addMissingBooksToDatabases(uniqueBooks, localBooks, remoteBooks);
  }

  Future<void> _deleteUserBooksFromDatabases(
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

  Future<void> _addMissingBooksToDatabases(
    List<DbBook> uniqueBooks,
    List<DbBook> localBooks,
    List<DbBook> remoteBooks,
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
}
