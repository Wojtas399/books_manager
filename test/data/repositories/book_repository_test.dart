import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/id_generator.dart';
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

class MockIdGenerator extends Mock implements IdGenerator {}

void main() {
  final bookSynchronizer = MockBookSynchronizer();
  final bookLocalDbService = MockBookLocalDbService();
  final bookRemoteDbService = MockBookRemoteDbService();
  final device = MockDevice();
  final idGenerator = MockIdGenerator();
  late BookRepository repository;
  const String userId = 'u1';

  BookRepository createRepository({
    List<Book> books = const [],
  }) {
    return BookRepository(
      bookSynchronizer: bookSynchronizer,
      bookLocalDbService: bookLocalDbService,
      bookRemoteDbService: bookRemoteDbService,
      device: device,
      idGenerator: idGenerator,
      books: books,
    );
  }

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(bookSynchronizer);
    reset(bookLocalDbService);
    reset(bookRemoteDbService);
    reset(device);
    reset(idGenerator);
  });

  group(
    'refresh user books',
    () {
      setUp(() {
        repository = createRepository();
        when(
          () => bookSynchronizer.synchronizeUnmodifiedUserBooks(userId: userId),
        ).thenAnswer((_) async => '');
        when(
          () => bookSynchronizer.synchronizeUserBooksMarkedAsDeleted(
            userId: userId,
          ),
        ).thenAnswer((_) async => '');
        when(
          () => bookSynchronizer.synchronizeUserBooksMarkedAsAdded(
            userId: userId,
          ),
        ).thenAnswer((_) async => '');
        when(
          () => bookSynchronizer.synchronizeUserBooksMarkedAsUpdated(
            userId: userId,
          ),
        ).thenAnswer((_) async => '');
      });

      test(
        'device has not internet connection, should not do anything',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);

          await repository.refreshUserBooks(userId: userId);

          verifyNever(
            () => bookSynchronizer.synchronizeUnmodifiedUserBooks(
              userId: userId,
            ),
          );
          verifyNever(
            () => bookSynchronizer.synchronizeUserBooksMarkedAsDeleted(
              userId: userId,
            ),
          );
          verifyNever(
            () => bookSynchronizer.synchronizeUserBooksMarkedAsAdded(
              userId: userId,
            ),
          );
          verifyNever(
            () => bookSynchronizer.synchronizeUserBooksMarkedAsUpdated(
              userId: userId,
            ),
          );
        },
      );

      test(
        'device has internet connection, should call methods responsible for synchronization process',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);

          await repository.refreshUserBooks(userId: userId);

          verify(
            () => bookSynchronizer.synchronizeUnmodifiedUserBooks(
              userId: userId,
            ),
          ).called(1);
          verify(
            () => bookSynchronizer.synchronizeUserBooksMarkedAsDeleted(
              userId: userId,
            ),
          ).called(1);
          verify(
            () => bookSynchronizer.synchronizeUserBooksMarkedAsAdded(
              userId: userId,
            ),
          ).called(1);
          verify(
            () => bookSynchronizer.synchronizeUserBooksMarkedAsUpdated(
              userId: userId,
            ),
          ).called(1);
        },
      );
    },
  );

  test(
    'get book by id, should return stream which contains book with given id',
    () async {
      final List<Book> books = [
        createBook(id: 'b1', status: BookStatus.unread),
        createBook(id: 'b2', status: BookStatus.inProgress),
        createBook(id: 'b3', status: BookStatus.finished),
      ];
      final Book expectedBook = createBook(
        id: 'b3',
        status: BookStatus.finished,
      );
      repository = createRepository(books: books);

      final Stream<Book> book$ = repository.getBookById(bookId: 'b3');

      expect(await book$.first, expectedBook);
    },
  );

  test(
    'get books by user id, should return stream which contains books belonging to user',
    () async {
      final List<Book> books = [
        createBook(id: 'b1', userId: userId, status: BookStatus.unread),
        createBook(id: 'b2', status: BookStatus.unread),
        createBook(id: 'b3', userId: userId, status: BookStatus.unread),
      ];
      final List<Book> expectedBooks = [books.first, books.last];
      repository = createRepository(books: books);

      final Stream<List<Book>> userBooks$ = repository.getBooksByUserId(
        userId: userId,
      );

      expect(await userBooks$.first, expectedBooks);
    },
  );

  test(
    'load user books, should load user books from local db and assign them to stream',
    () async {
      const BookStatus bookStatus = BookStatus.unread;
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1', userId: userId, status: bookStatus.name),
        createDbBook(id: 'b2', userId: userId, status: bookStatus.name),
      ];
      final List<Book> expectedBooks = [
        createBook(id: 'b1', userId: userId, status: bookStatus),
        createBook(id: 'b2', userId: userId, status: bookStatus),
      ];
      when(
        () => bookLocalDbService.loadUserBooks(
          userId: userId,
          bookStatus: bookStatus.name,
        ),
      ).thenAnswer((_) async => dbBooks);

      await repository.loadUserBooks(userId: userId, bookStatus: bookStatus);

      expect(
        await repository.getBooksByUserId(userId: userId).first,
        expectedBooks,
      );
      verify(
        () => bookLocalDbService.loadUserBooks(
          userId: userId,
          bookStatus: bookStatus.name,
        ),
      ).called(1);
    },
  );

  group(
    'add new book',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';
      const BookStatus status = BookStatus.unread;
      final Uint8List imageData = Uint8List(10);
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 0;
      const int allPagesAmount = 200;
      final DbBook dbBook = createDbBook(
        id: bookId,
        imageData: imageData,
        userId: userId,
        status: status.name,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );
      final Book addedBook = createBook(
        id: bookId,
        imageData: imageData,
        userId: userId,
        status: status,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );

      setUp(() {
        when(
          () => idGenerator.generateRandomId(),
        ).thenReturn(bookId);
      });

      test(
        'should only call method responsible for adding book to local db with sync state as added if device has not internet connection',
        () async {
          const SyncState syncState = SyncState.added;
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);
          when(
            () => bookLocalDbService.addBook(
              dbBook: dbBook,
              syncState: syncState,
            ),
          ).thenAnswer((_) async => '');

          await repository.addNewBook(
            userId: userId,
            status: status,
            imageData: imageData,
            title: title,
            author: author,
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          );

          verify(
            () => bookLocalDbService.addBook(
              dbBook: dbBook,
              syncState: syncState,
            ),
          ).called(1);
          expect(
            await repository.getBooksByUserId(userId: userId).first,
            [addedBook],
          );
        },
      );

      test(
        'should call methods responsible for adding book to local and remote db if device has internet connection',
        () async {
          const SyncState syncState = SyncState.none;
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);
          when(
            () => bookLocalDbService.addBook(
              dbBook: dbBook,
              syncState: syncState,
            ),
          ).thenAnswer((_) async => '');
          when(
            () => bookRemoteDbService.addBook(dbBook: dbBook),
          ).thenAnswer((_) async => '');

          await repository.addNewBook(
            userId: userId,
            status: status,
            imageData: imageData,
            title: title,
            author: author,
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          );

          verify(
            () => bookLocalDbService.addBook(
              dbBook: dbBook,
              syncState: syncState,
            ),
          ).called(1);
          verify(
            () => bookRemoteDbService.addBook(dbBook: dbBook),
          ).called(1);
          expect(
            await repository.getBooksByUserId(userId: userId).first,
            [addedBook],
          );
        },
      );
    },
  );

  group(
    'update book data',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';
      final Book currentBook = createBook(id: bookId, userId: userId);
      const String newTitle = 'newTitle';
      final DbBook updatedDbBook = createDbBook(
        id: bookId,
        userId: userId,
        title: newTitle,
      );
      final Book updatedBook = currentBook.copyWith(title: newTitle);

      setUp(() {
        when(
          () => bookLocalDbService.updateBookData(
            bookId: bookId,
            title: newTitle,
            syncState: any(named: 'syncState'),
          ),
        ).thenAnswer((_) async => updatedDbBook);
        repository = createRepository(books: [currentBook]);
      });

      test(
        'device has not internet connection, should only call method responsible for updating book data in local db with sync state set to updated and should update book in list',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);

          await repository.updateBookData(
            bookId: bookId,
            title: newTitle,
          );

          verify(
            () => bookLocalDbService.updateBookData(
              bookId: bookId,
              title: newTitle,
              syncState: SyncState.updated,
            ),
          ).called(1);
          expect(
            await repository.getBookById(bookId: bookId).first,
            updatedBook,
          );
        },
      );

      test(
        'device has internet connection, should call methods responsible for updating book data in local and remote db and should update book in list',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);
          when(
            () => bookRemoteDbService.updateBookData(
              bookId: bookId,
              userId: userId,
              title: newTitle,
            ),
          ).thenAnswer((_) async => '');

          await repository.updateBookData(
            bookId: bookId,
            title: newTitle,
          );

          verify(
            () => bookRemoteDbService.updateBookData(
              bookId: bookId,
              userId: userId,
              title: newTitle,
            ),
          ).called(1);
          verify(
            () => bookLocalDbService.updateBookData(
              bookId: bookId,
              title: newTitle,
              syncState: SyncState.none,
            ),
          ).called(1);
          expect(
            await repository.getBookById(bookId: bookId).first,
            updatedBook,
          );
        },
      );
    },
  );

  group(
    'update book image',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';
      final Uint8List imageData = Uint8List(1);
      final DbBook updatedDbBook = createDbBook(
        id: bookId,
        userId: userId,
        imageData: imageData,
      );
      final Book originalBook = createBook(
        id: bookId,
        userId: userId,
        imageData: Uint8List(10),
      );
      final Book updatedBook = originalBook.copyWith(imageData: imageData);

      setUp(() {
        when(
          () => bookLocalDbService.updateBookImage(
            bookId: bookId,
            userId: userId,
            imageData: imageData,
          ),
        ).thenAnswer((_) async => updatedDbBook);
        repository = createRepository(books: [originalBook]);
      });

      test(
        'device has internet connection, should update image in remote and local db and should update book in list',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);
          when(
            () => bookRemoteDbService.updateBookImage(
              bookId: bookId,
              userId: userId,
              imageData: imageData,
            ),
          ).thenAnswer((_) async => '');

          await repository.updateBookImage(
            bookId: bookId,
            imageData: imageData,
          );

          verify(
            () => bookRemoteDbService.updateBookImage(
              bookId: bookId,
              userId: userId,
              imageData: imageData,
            ),
          ).called(1);
          verify(
            () => bookLocalDbService.updateBookImage(
              bookId: bookId,
              userId: userId,
              imageData: imageData,
            ),
          ).called(1);
          expect(
            await repository.getBookById(bookId: bookId).first,
            updatedBook,
          );
        },
      );

      test(
        'device has not internet connection, should update image in local db, should set book sync state to updated in local db and should update book in list',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);
          when(
            () => bookLocalDbService.updateBookData(
              bookId: bookId,
              syncState: SyncState.updated,
            ),
          ).thenAnswer((_) async => updatedDbBook);

          await repository.updateBookImage(
            bookId: bookId,
            imageData: imageData,
          );

          verify(
            () => bookLocalDbService.updateBookImage(
              bookId: bookId,
              userId: userId,
              imageData: imageData,
            ),
          ).called(1);
          verify(
            () => bookLocalDbService.updateBookData(
              bookId: bookId,
              syncState: SyncState.updated,
            ),
          ).called(1);
          expect(
            await repository.getBookById(bookId: bookId).first,
            updatedBook,
          );
        },
      );
    },
  );

  group(
    'delete book',
    () {
      const String bookId = 'b1';
      final Book book = createBook(id: bookId, userId: userId);

      setUp(() {
        repository = createRepository(books: [book]);
      });

      test(
        'should call methods responsible for deleting book from remote and local db if device has internet connection',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => true);
          when(
            () =>
                bookRemoteDbService.deleteBook(userId: userId, bookId: bookId),
          ).thenAnswer((_) async => '');
          when(
            () => bookLocalDbService.deleteBook(userId: userId, bookId: bookId),
          ).thenAnswer((_) async => '');

          await repository.deleteBook(bookId: bookId);

          verify(
            () =>
                bookRemoteDbService.deleteBook(userId: userId, bookId: bookId),
          ).called(1);
          verify(
            () => bookLocalDbService.deleteBook(userId: userId, bookId: bookId),
          ).called(1);
        },
      );

      test(
        'should call method responsible for updating book with sync state as deleted if device has not internet connection',
        () async {
          when(
            () => device.hasInternetConnection(),
          ).thenAnswer((_) async => false);
          when(
            () => bookLocalDbService.updateBookData(
              bookId: bookId,
              syncState: SyncState.deleted,
            ),
          ).thenAnswer((_) async => createDbBook());

          await repository.deleteBook(bookId: bookId);

          verify(
            () => bookLocalDbService.updateBookData(
              bookId: bookId,
              syncState: SyncState.deleted,
            ),
          ).called(1);
        },
      );
    },
  );

  test(
    'reset, should reset stream of books',
    () async {
      final List<Book> books = [
        createBook(id: 'b1', userId: userId, status: BookStatus.unread),
        createBook(id: 'b2', userId: userId, status: BookStatus.inProgress),
      ];
      repository = createRepository(books: books);

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
