import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
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

  setUpAll(() {
    registerFallbackValue(FakeDbBook());
  });

  setUp(() {
    synchronizer = BookSynchronizer(
      bookLocalDbService: bookLocalDbService,
      bookRemoteDbService: bookRemoteDbService,
    );
  });

  tearDown(() {
    reset(bookLocalDbService);
    reset(bookRemoteDbService);
  });

  test(
    'delete user books marked as deleted, should load ids of user books marked as deleted from local db and should delete them from both databases',
    () async {
      const String userId = 'u1';
      const List<String> deletedBooksIds = ['b1', 'b3'];
      when(
        () => bookLocalDbService.loadIdsOfUserBooksMarkedAsDeleted(
          userId: userId,
        ),
      ).thenAnswer((_) async => deletedBooksIds);
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

      await synchronizer.deleteUserBooksMarkedAsDeleted(userId: userId);

      verify(
        () => bookRemoteDbService.deleteBook(
          userId: userId,
          bookId: deletedBooksIds.first,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(
          userId: userId,
          bookId: deletedBooksIds.first,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.deleteBook(
          userId: userId,
          bookId: deletedBooksIds.last,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(
          userId: userId,
          bookId: deletedBooksIds.last,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user books, should add missing books to local and remote databases',
    () async {
      const String userId = 'u1';
      final List<DbBook> localBooks = [
        createDbBook(id: 'b2'),
        createDbBook(id: 'b3'),
        createDbBook(id: 'b4'),
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
        () => bookLocalDbService.addBook(dbBook: any(named: 'dbBook')),
      ).thenAnswer((_) async => remoteBooks.first);
      when(
        () => bookRemoteDbService.addBook(dbBook: any(named: 'dbBook')),
      ).thenAnswer((_) async => '');

      await synchronizer.synchronizeUserBooks(userId: userId);

      verify(
        () => bookLocalDbService.addBook(dbBook: remoteBooks.first),
      ).called(1);
      verify(
        () => bookRemoteDbService.addBook(dbBook: localBooks[1]),
      ).called(1);
      verify(
        () => bookRemoteDbService.addBook(dbBook: localBooks.last),
      ).called(1);
    },
  );
}
