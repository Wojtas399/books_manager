import 'package:app/data/data_sources/local_db/services/book_local_db_service.dart';
import 'package:app/data/data_sources/remote_db/services/book_remote_db_service.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/device.dart';
import 'package:app/models/error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookLocalDbService extends Mock implements BookLocalDbService {}

class MockBookRemoteDbService extends Mock implements BookRemoteDbService {}

class MockDevice extends Mock implements Device {}

void main() {
  final bookLocalDbService = MockBookLocalDbService();
  final bookRemoteDbService = MockBookRemoteDbService();
  final device = MockDevice();
  late BookRepository repository;
  const String userId = 'u1';

  setUp(() {
    repository = BookRepository(
      bookLocalDbService: bookLocalDbService,
      bookRemoteDbService: bookRemoteDbService,
      device: device,
    );
  });

  tearDown(() {
    reset(bookLocalDbService);
    reset(bookRemoteDbService);
    reset(device);
  });

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
        () => bookLocalDbService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadAllBooksByUserId(userId: userId);
      final Stream<List<Book>> userBooks$ = repository.getBooksByUserId(
        userId: userId,
      );

      expect(await userBooks$.first, expectedBooks);
    },
  );

  test(
    'refresh user books, should throw network error if device has not internet connection',
    () async {
      when(
        () => device.hasInternetConnection(),
      ).thenAnswer((_) async => false);

      try {
        await repository.refreshUserBooks(userId: userId);
      } on NetworkError catch (networkError) {
        expect(
          networkError,
          NetworkError(networkErrorCode: NetworkErrorCode.lossOfConnection),
        );
      }
    },
  );

  test(
    'refresh user books, should add missing books to local and remote db',
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
        () => device.hasInternetConnection(),
      ).thenAnswer((_) async => true);
      when(
        () => bookLocalDbService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => localBooks);
      when(
        () => bookRemoteDbService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => remoteBooks);
      when(
        () => bookLocalDbService.addBook(dbBook: remoteBooks.first),
      ).thenAnswer((_) async => remoteBooks.first);
      when(
        () => bookRemoteDbService.addBook(dbBook: localBooks.last),
      ).thenAnswer((_) async => '');

      await repository.refreshUserBooks(userId: userId);

      verify(
        () => bookLocalDbService.addBook(dbBook: remoteBooks.first),
      ).called(1);
      verify(
        () => bookRemoteDbService.addBook(dbBook: localBooks.last),
      ).called(1);
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
        () => bookLocalDbService.loadBooksByUserId(userId: userId),
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
        () => bookLocalDbService.loadBooksByUserId(userId: userId),
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
