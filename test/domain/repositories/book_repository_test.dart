import 'package:app/database/entities/db_book.dart';
import 'package:app/database/firebase/services/fire_book_service.dart';
import 'package:app/database/sqlite/services/sqlite_book_service.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/domain/repositories/book_repository.dart';
import 'package:app/models/device.dart';
import 'package:app/models/error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSqliteBookService extends Mock implements SqliteBookService {}

class MockFirebaseBookService extends Mock implements FirebaseBookService {}

class MockDevice extends Mock implements Device {}

void main() {
  final sqliteBookService = MockSqliteBookService();
  final firebaseBookService = MockFirebaseBookService();
  final device = MockDevice();
  late BookRepository repository;

  setUp(() {
    repository = BookRepository(
      sqliteBookService: sqliteBookService,
      firebaseBookService: firebaseBookService,
      device: device,
    );
  });

  tearDown(() {
    reset(sqliteBookService);
    reset(firebaseBookService);
    reset(device);
  });

  test(
    'get books by user id, should return stream which contains books belonging to user',
    () async {
      const String userId = 'u1';
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1'),
        createDbBook(id: 'b2', userId: userId),
        createDbBook(id: 'b3'),
      ];
      final List<Book> expectedBooks = [
        createBook(id: 'b2', userId: userId),
      ];
      when(
        () => sqliteBookService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadAllBooksByUserId(userId: userId);
      final Stream<List<Book>> books$ = repository.getBooksByUserId(
        userId: userId,
      );

      verify(
        () => sqliteBookService.loadBooksByUserId(userId: userId),
      ).called(1);
      expect(await books$.first, expectedBooks);
    },
  );

  group(
    'refresh user books',
    () {
      const String userId = 'u1';
      final List<DbBook> sqliteBooks = [
        createDbBook(id: 'b2'),
        createDbBook(id: 'b3'),
      ];
      final List<DbBook> firebaseBooks = [
        createDbBook(id: 'b1'),
        createDbBook(id: 'b2')
      ];

      setUp(() {
        when(
          () => sqliteBookService.loadBooksByUserId(userId: userId),
        ).thenAnswer((_) async => sqliteBooks);
        when(
          () => firebaseBookService.loadBooksByUserId(userId: userId),
        ).thenAnswer((_) async => firebaseBooks);
        when(
          () => sqliteBookService.addNewBook(firebaseBooks.first),
        ).thenAnswer((_) async => firebaseBooks.first);
        when(
          () => firebaseBookService.addNewBook(sqliteBooks.last),
        ).thenAnswer((_) async => sqliteBooks.last);
      });

      test(
        'should synchronize books between databases',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);

          await repository.refreshUserBooks(userId: userId);

          verify(
            () => sqliteBookService.addNewBook(firebaseBooks.first),
          ).called(1);
          verify(
            () => firebaseBookService.addNewBook(sqliteBooks.last),
          ).called(1);
        },
      );

      test(
        'should not synchronize books between databases if there is no internet connection',
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
            verifyNever(
              () => sqliteBookService.addNewBook(firebaseBooks.first),
            );
            verifyNever(
              () => firebaseBookService.addNewBook(sqliteBooks.last),
            );
          }
        },
      );
    },
  );

  test(
    'load all books by user id, should load books and assign them to stream',
    () async {
      const String userId = 'u1';
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1', userId: userId),
        createDbBook(id: 'b2', userId: userId),
      ];
      final List<Book> expectedBooks = [
        createBook(id: 'b1', userId: userId),
        createBook(id: 'b2', userId: userId),
      ];
      when(
        () => sqliteBookService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadAllBooksByUserId(userId: userId);
      final Stream<List<Book>> books$ = repository.getBooksByUserId(
        userId: userId,
      );

      expect(await books$.first, expectedBooks);
    },
  );

  group(
    'add new book',
    () {
      const String userId = 'u1';
      final Book bookToAdd = createBook(
        userId: userId,
        title: 'title',
        author: 'author',
      );
      final DbBook dbBookToAdd = createDbBook(
        userId: bookToAdd.userId,
        title: bookToAdd.title,
        author: bookToAdd.author,
      );
      final DbBook addedDbBook = dbBookToAdd.copyWith(id: 'b1');
      final Book addedBook = bookToAdd.copyWith(id: addedDbBook.id);

      setUp(() {
        when(
          () => sqliteBookService.addNewBook(dbBookToAdd),
        ).thenAnswer((_) async => addedDbBook);
        when(
          () => firebaseBookService.addNewBook(addedDbBook),
        ).thenAnswer((_) async => '');
      });

      test(
        'should call methods responsible for adding new book to sqlite and firebase and should assign new book to books stream',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);

          await repository.addNewBook(book: bookToAdd);
          final Stream<List<Book>> books$ = repository.getBooksByUserId(
            userId: userId,
          );

          verify(
            () => sqliteBookService.addNewBook(dbBookToAdd),
          ).called(1);
          verify(
            () => firebaseBookService.addNewBook(addedDbBook),
          ).called(1);
          expect(await books$.first, [addedBook]);
        },
      );

      test(
        'should only call method responsible for adding new book to sqlite if there is no internet connection',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);

          await repository.addNewBook(book: bookToAdd);
          final Stream<List<Book>> books$ = repository.getBooksByUserId(
            userId: userId,
          );

          verify(
            () => sqliteBookService.addNewBook(dbBookToAdd),
          ).called(1);
          verifyNever(
            () => firebaseBookService.addNewBook(addedDbBook),
          );
          expect(await books$.first, [addedBook]);
        },
      );
    },
  );
}
