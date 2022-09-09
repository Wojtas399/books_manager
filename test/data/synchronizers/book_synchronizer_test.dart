import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookLocalDbService extends Mock implements BookLocalDbService {}

class MockBookRemoteDbService extends Mock implements BookRemoteDbService {}

class FakeDbBook extends Fake implements DbBook {}

void main() {
  final bookLocalDbService = MockBookLocalDbService();
  final bookRemoteDbService = MockBookRemoteDbService();
  late BookSynchronizer synchronizer;
  const String userId = 'u1';

  setUpAll(() {
    registerFallbackValue(FakeDbBook());
  });

  setUp(() {
    synchronizer = BookSynchronizer(
      bookLocalDbService: bookLocalDbService,
      bookRemoteDbService: bookRemoteDbService,
    );
    when(
      () => bookLocalDbService.updateBookData(
        bookId: any(named: 'bookId'),
        syncState: any(named: 'syncState'),
      ),
    ).thenAnswer((_) async => createDbBook());
  });

  tearDown(() {
    reset(bookLocalDbService);
    reset(bookRemoteDbService);
  });

  test(
    'synchronize unmodified user books, should add missing books to local and remote db',
    () async {
      final List<DbBook> localBooks = [
        createDbBook(id: 'b2'),
        createDbBook(id: 'b3'),
      ];
      final List<DbBook> remoteBooks = [
        createDbBook(id: 'b1'),
        createDbBook(id: 'b2'),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => localBooks);
      when(
        () => bookRemoteDbService.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => remoteBooks);
      when(
        () => bookLocalDbService.addBook(dbBook: remoteBooks.first),
      ).thenAnswer((_) async => '');
      when(
        () => bookRemoteDbService.addBook(dbBook: localBooks.last),
      ).thenAnswer((_) async => '');

      await synchronizer.synchronizeUnmodifiedUserBooks(userId: userId);

      verify(
        () => bookLocalDbService.addBook(dbBook: remoteBooks.first),
      ).called(1);
      verify(
        () => bookRemoteDbService.addBook(dbBook: localBooks.last),
      ).called(1);
    },
  );

  test(
    'synchronize user books marked as added, should load db books marked as added from local db, should add them to remote db and should update their sync state to none',
    () async {
      final List<DbBook> dbBooksMarkedAsAdded = [
        createDbBook(id: 'b1'),
        createDbBook(id: 'b2'),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(
          userId: userId,
          syncState: SyncState.added,
        ),
      ).thenAnswer((_) async => dbBooksMarkedAsAdded);
      when(
        () => bookRemoteDbService.addBook(dbBook: any(named: 'dbBook')),
      ).thenAnswer((_) async => '');

      await synchronizer.synchronizeUserBooksMarkedAsAdded(userId: userId);

      verify(
        () => bookRemoteDbService.addBook(
          dbBook: dbBooksMarkedAsAdded.first,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.addBook(
          dbBook: dbBooksMarkedAsAdded.last,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: dbBooksMarkedAsAdded.first.id,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: dbBooksMarkedAsAdded.last.id,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user books marked as updated, should load db books marked as updated from local db and should update them in remote db',
    () async {
      final List<DbBook> dbBooksMarkedAsUpdated = [
        createDbBook(id: 'b1', userId: userId),
        createDbBook(id: 'b2', userId: userId),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(
          userId: userId,
          syncState: SyncState.updated,
        ),
      ).thenAnswer((_) async => dbBooksMarkedAsUpdated);
      when(
        () => bookRemoteDbService.updateBookData(
          bookId: any(named: 'bookId'),
          userId: any(named: 'userId'),
          status: any(named: 'status'),
          title: any(named: 'title'),
          author: any(named: 'author'),
          readPagesAmount: any(named: 'readPagesAmount'),
          allPagesAmount: any(named: 'allPagesAmount'),
        ),
      ).thenAnswer((_) async => '');
      when(
        () => bookRemoteDbService.updateBookImage(
          bookId: any(named: 'bookId'),
          userId: userId,
          imageData: any(named: 'imageData'),
        ),
      ).thenAnswer((_) async => '');

      await synchronizer.synchronizeUserBooksMarkedAsUpdated(userId: userId);

      verify(
        () => bookRemoteDbService.updateBookData(
          bookId: dbBooksMarkedAsUpdated.first.id,
          userId: dbBooksMarkedAsUpdated.first.userId,
          status: dbBooksMarkedAsUpdated.first.status,
          title: dbBooksMarkedAsUpdated.first.title,
          author: dbBooksMarkedAsUpdated.first.author,
          readPagesAmount: dbBooksMarkedAsUpdated.first.readPagesAmount,
          allPagesAmount: dbBooksMarkedAsUpdated.first.allPagesAmount,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.updateBookData(
          bookId: dbBooksMarkedAsUpdated.last.id,
          userId: dbBooksMarkedAsUpdated.last.userId,
          status: dbBooksMarkedAsUpdated.last.status,
          title: dbBooksMarkedAsUpdated.last.title,
          author: dbBooksMarkedAsUpdated.last.author,
          readPagesAmount: dbBooksMarkedAsUpdated.last.readPagesAmount,
          allPagesAmount: dbBooksMarkedAsUpdated.last.allPagesAmount,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.updateBookImage(
          bookId: dbBooksMarkedAsUpdated.first.id,
          userId: userId,
          imageData: dbBooksMarkedAsUpdated.first.imageData,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.updateBookImage(
          bookId: dbBooksMarkedAsUpdated.last.id,
          userId: userId,
          imageData: dbBooksMarkedAsUpdated.last.imageData,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: dbBooksMarkedAsUpdated.first.id,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: dbBooksMarkedAsUpdated.last.id,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user books marked as deleted, should load db books marked as deleted from local db and should delete them from both databases',
    () async {
      final List<DbBook> dbBooksMarkedAsDeleted = [
        createDbBook(id: 'b1'),
        createDbBook(id: 'b3'),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(
            userId: userId, syncState: SyncState.deleted),
      ).thenAnswer((_) async => dbBooksMarkedAsDeleted);
      when(
        () => bookRemoteDbService.deleteBook(
          userId: any(named: 'userId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenAnswer((_) async => '');
      when(
        () => bookLocalDbService.deleteBook(
          userId: any(named: 'userId'),
          bookId: any(named: 'bookId'),
        ),
      ).thenAnswer((_) async => '');

      await synchronizer.synchronizeUserBooksMarkedAsDeleted(userId: userId);

      verify(
        () => bookRemoteDbService.deleteBook(
          userId: userId,
          bookId: dbBooksMarkedAsDeleted.first.id,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(
          userId: userId,
          bookId: dbBooksMarkedAsDeleted.first.id,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.deleteBook(
          userId: userId,
          bookId: dbBooksMarkedAsDeleted.last.id,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(
          userId: userId,
          bookId: dbBooksMarkedAsDeleted.last.id,
        ),
      ).called(1);
    },
  );
}
