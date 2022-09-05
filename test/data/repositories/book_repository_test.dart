import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/device.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookSynchronizer extends Mock implements BookSynchronizer {}

class MockBookLocalDbService extends Mock implements BookLocalDbService {}

class MockBookRemoteDbService extends Mock implements BookRemoteDbService {}

class MockDevice extends Mock implements Device {}

void main() {
  final bookSynchronizer = MockBookSynchronizer();
  final bookLocalDbService = MockBookLocalDbService();
  final bookRemoteDbService = MockBookRemoteDbService();
  final device = MockDevice();
  late BookRepository repository;
  const String userId = 'u1';

  setUp(() {
    repository = BookRepository(
      bookSynchronizer: bookSynchronizer,
      bookLocalDbService: bookLocalDbService,
      bookRemoteDbService: bookRemoteDbService,
      device: device,
    );
  });

  tearDown(() {
    reset(bookSynchronizer);
    reset(bookLocalDbService);
    reset(bookRemoteDbService);
    reset(device);
  });

  group(
    'refresh user books',
    () {
      setUp(() {
        when(
          () => bookSynchronizer.deleteUserBooksMarkedAsDeleted(userId: userId),
        ).thenAnswer((_) async => '');
        when(
          () => bookSynchronizer.synchronizeUserBooks(userId: userId),
        ).thenAnswer((_) async => '');
      });

      test(
        'refresh user books, should not call methods responsible for deleting user books marked as deleted and for synchronizing user books if device has not internet connection',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);

          await repository.refreshUserBooks(userId: userId);

          verifyNever(
            () => bookSynchronizer.deleteUserBooksMarkedAsDeleted(
              userId: userId,
            ),
          );
          verifyNever(
            () => bookSynchronizer.synchronizeUserBooks(userId: userId),
          );
        },
      );

      test(
        'refresh user books, should call method responsible for deleting user books marked as deleted and for synchronizing user books if device has internet connection',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);

          await repository.refreshUserBooks(userId: userId);

          verify(
            () => bookSynchronizer.deleteUserBooksMarkedAsDeleted(
              userId: userId,
            ),
          ).called(1);
          verify(
            () => bookSynchronizer.synchronizeUserBooks(userId: userId),
          ).called(1);
        },
      );
    },
  );

  test(
    'get book by id, should return stream which contains book with given id',
    () async {
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1'),
        createDbBook(id: 'b2'),
        createDbBook(id: 'b3'),
      ];
      final Book expectedBook = createBook(id: 'b3');
      when(
        () => bookLocalDbService.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadAllBooksByUserId(userId: userId);
      final Stream<Book> book$ = repository.getBookById(bookId: 'b3');

      expect(await book$.first, expectedBook);
    },
  );

  test(
    'get books by user id, should return stream which contains books belonging to user',
    () async {
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1', userId: userId),
        createDbBook(id: 'b2'),
        createDbBook(id: 'b3', userId: userId),
      ];
      final List<Book> expectedBooks = [
        createBook(id: 'b1', userId: userId),
        createBook(id: 'b3', userId: userId),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadAllBooksByUserId(userId: userId);
      final Stream<List<Book>> userBooks$ = repository.getBooksByUserId(
        userId: userId,
      );

      expect(await userBooks$.first, expectedBooks);
    },
  );

  test(
    'load all books by user id, should load all user books from local db and assign them to stream',
    () async {
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1', userId: userId),
        createDbBook(id: 'b2', userId: userId),
      ];
      final List<Book> expectedBooks = [
        createBook(id: 'b1', userId: userId),
        createBook(id: 'b2', userId: userId),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadAllBooksByUserId(userId: userId);

      expect(
        await repository.getBooksByUserId(userId: userId).first,
        expectedBooks,
      );
    },
  );

  group(
    'add new book',
    () {
      final Book bookToAdd = createBook(userId: userId, title: 'title');
      final DbBook dbBookToAdd = createDbBook(
        userId: bookToAdd.userId,
        title: bookToAdd.title,
      );
      final DbBook addedDbBook = dbBookToAdd.copyWith(id: 'b1');
      final Book addedBook = bookToAdd.copyWith(id: addedDbBook.id);

      setUp(() {
        when(
          () => bookLocalDbService.addBook(dbBook: dbBookToAdd),
        ).thenAnswer((_) async => addedDbBook);
        when(
          () => bookRemoteDbService.addBook(dbBook: addedDbBook),
        ).thenAnswer((_) async => '');
      });

      test(
        'should add book only to local db if there is no internet connection',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);

          await repository.addNewBook(book: bookToAdd);

          verify(
            () => bookLocalDbService.addBook(dbBook: dbBookToAdd),
          ).called(1);
          verifyNever(
            () => bookRemoteDbService.addBook(dbBook: dbBookToAdd),
          );
          expect(
            await repository.getBooksByUserId(userId: userId).first,
            [addedBook],
          );
        },
      );

      test(
        'should add book to local and remote db if there is internet connection',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);

          await repository.addNewBook(book: bookToAdd);

          verify(
            () => bookLocalDbService.addBook(dbBook: dbBookToAdd),
          ).called(1);
          verify(
            () => bookRemoteDbService.addBook(dbBook: addedDbBook),
          ).called(1);
          expect(
            await repository.getBooksByUserId(userId: userId).first,
            [addedBook],
          );
        },
      );
    },
  );

  test(
    'delete book, should call methods responsible for deleting book from remote and local db if device has internet connection',
    () async {
      const String bookId = 'b1';
      when(
        () => device.hasInternetConnection(),
      ).thenAnswer((_) async => true);
      when(
        () => bookRemoteDbService.deleteBook(userId: userId, bookId: bookId),
      ).thenAnswer((_) async => '');
      when(
        () => bookLocalDbService.deleteBook(userId: userId, bookId: bookId),
      ).thenAnswer((_) async => '');

      await repository.deleteBook(userId: userId, bookId: bookId);

      verify(
        () => bookRemoteDbService.deleteBook(userId: userId, bookId: bookId),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(userId: userId, bookId: bookId),
      ).called(1);
    },
  );

  test(
    'delete book, should call method responsible for marking book as deleted in local db if device has not internet connection',
    () async {
      const String bookId = 'b1';
      when(
        () => device.hasInternetConnection(),
      ).thenAnswer((_) async => false);
      when(
        () => bookLocalDbService.markBookAsDeleted(bookId: bookId),
      ).thenAnswer((_) async => '');

      await repository.deleteBook(userId: userId, bookId: bookId);

      verify(
        () => bookLocalDbService.markBookAsDeleted(bookId: bookId),
      ).called(1);
    },
  );

  test(
    'reset, should reset stream of books',
    () async {
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1', userId: userId),
        createDbBook(id: 'b2', userId: userId),
      ];
      final List<Book> books = [
        createBook(id: 'b1', userId: userId),
        createBook(id: 'b2', userId: userId),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadAllBooksByUserId(userId: userId);
      final List<Book> loadedBooks =
          await repository.getBooksByUserId(userId: userId).first;
      repository.reset();
      final List<Book> resetedBooks =
          await repository.getBooksByUserId(userId: userId).first;

      expect(loadedBooks, books);
      expect(resetedBooks, []);
    },
  );
}
