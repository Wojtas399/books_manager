import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/local_db/mock_book_local_db_service.dart';
import '../../mocks/mock_device.dart';
import '../../mocks/remote_db/mock_book_remote_db_service.dart';
import '../mocks/mock_book_synchronizer.dart';
import '../mocks/mock_id_generator.dart';

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
    'initialize for user',
    () {
      Future<void> callInitializeForUserMethod() async {
        await repository.initializeForUser(userId: userId);
      }

      setUp(() {
        repository = createRepository();
        bookSynchronizer.mockSynchronizeUnmodifiedUserBooks();
        bookSynchronizer.mockSynchronizeUserBooksMarkedAsDeleted();
        bookSynchronizer.mockSynchronizeUserBooksMarkedAsAdded();
        bookSynchronizer.mockSynchronizeUserBooksMarkedAsUpdated();
      });

      test(
        'device has not internet connection, should not do anything',
        () async {
          device.mockHasDeviceInternetConnection(value: false);

          await callInitializeForUserMethod();

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
          device.mockHasDeviceInternetConnection(value: true);

          await callInitializeForUserMethod();

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

      final Stream<Book?> book$ = repository.getBookById(bookId: 'b3');

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

      final Stream<List<Book>?> userBooks$ = repository.getBooksByUserId(
        userId: userId,
      );

      expect(await userBooks$.first, expectedBooks);
    },
  );

  test(
    'load user books, should load user books from local db and assign them to stream',
    () async {
      const BookStatus bookStatus = BookStatus.unread;
      final List<Book> books = [
        createBook(id: 'b1', userId: userId, status: bookStatus),
        createBook(id: 'b2', userId: userId, status: bookStatus),
      ];
      final List<Book> expectedBooks = [
        createBook(id: 'b1', userId: userId, status: bookStatus),
        createBook(id: 'b2', userId: userId, status: bookStatus),
      ];
      bookLocalDbService.mockLoadUserBooks(books: books);

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
      final Book book = createBook(
        id: bookId,
        imageData: imageData,
        userId: userId,
        status: status,
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

      Future<void> callAddNewBookMethod() async {
        await repository.addNewBook(
          userId: userId,
          status: status,
          imageData: imageData,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        );
      }

      setUp(() {
        bookLocalDbService.mockAddBook();
        bookRemoteDbService.mockAddBook();
        idGenerator.mockGenerateRandomId(id: bookId);
      });

      test(
        'should only call method responsible for adding book to local db with sync state as added if device has not internet connection',
        () async {
          const SyncState syncState = SyncState.added;
          device.mockHasDeviceInternetConnection(value: false);

          await callAddNewBookMethod();

          verify(
            () => bookLocalDbService.addBook(book: book, syncState: syncState),
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
          device.mockHasDeviceInternetConnection(value: true);

          await callAddNewBookMethod();

          verify(
            () => bookLocalDbService.addBook(book: book),
          ).called(1);
          verify(
            () => bookRemoteDbService.addBook(book: book),
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
      final Book updatedBook = currentBook.copyWith(title: newTitle);

      Future<void> callUpdateBookDataMethod() async {
        await repository.updateBookData(
          bookId: bookId,
          title: newTitle,
        );
      }

      setUp(() {
        bookLocalDbService.mockUpdateBookData(updatedBook: updatedBook);
        bookRemoteDbService.mockUpdateBookData();
        repository = createRepository(books: [currentBook]);
      });

      test(
        'device has not internet connection, should only call method responsible for updating book data in local db with sync state set to updated and should update book in list',
        () async {
          const SyncState syncState = SyncState.updated;
          device.mockHasDeviceInternetConnection(value: false);

          await callUpdateBookDataMethod();

          verify(
            () => bookLocalDbService.updateBookData(
              bookId: bookId,
              title: newTitle,
              syncState: syncState,
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
          device.mockHasDeviceInternetConnection(value: true);

          await callUpdateBookDataMethod();

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
      final Book originalBook = createBook(
        id: bookId,
        userId: userId,
        imageData: Uint8List(10),
      );
      final Book updatedBook = originalBook.copyWith(imageData: imageData);

      Future<void> callUpdateBookImageMethod() async {
        await repository.updateBookImage(
          bookId: bookId,
          imageData: imageData,
        );
      }

      setUp(() {
        bookLocalDbService.mockUpdateBookImage(updatedBook: updatedBook);
        bookRemoteDbService.mockUpdateBookImage();
        repository = createRepository(books: [originalBook]);
      });

      test(
        'device has internet connection, should update image in remote and local db and should update book in list',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await callUpdateBookImageMethod();

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
          device.mockHasDeviceInternetConnection(value: false);
          bookLocalDbService.mockUpdateBookData(updatedBook: updatedBook);

          await callUpdateBookImageMethod();

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
          device.mockHasDeviceInternetConnection(value: true);
          bookLocalDbService.mockDeleteBook();
          bookRemoteDbService.mockDeleteBook();

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
          device.mockHasDeviceInternetConnection(value: false);
          bookLocalDbService.mockUpdateBookData(updatedBook: createBook());

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

  group(
    'delete all user books',
    () {
      const String userId = 'u1';
      final List<Book> userBooks = [
        createBook(id: 'b1', userId: userId),
        createBook(id: 'b2', userId: userId),
      ];

      setUp(() {
        bookLocalDbService.mockLoadUserBooks(books: userBooks);
        bookLocalDbService.mockDeleteBook();
        bookLocalDbService.mockUpdateBookData(updatedBook: createBook());
        bookRemoteDbService.mockDeleteBook();
      });

      test(
        'device has internet connection, should delete each book and its image from remote and local db',
        () async {
          device.mockHasDeviceInternetConnection(value: true);

          await repository.deleteAllUserBooks(userId: userId);

          verify(
            () => bookLocalDbService.deleteBook(
              userId: userId,
              bookId: userBooks.first.id,
            ),
          ).called(1);
          verify(
            () => bookRemoteDbService.deleteBook(
              userId: userId,
              bookId: userBooks.first.id,
            ),
          ).called(1);
          verify(
            () => bookLocalDbService.deleteBook(
              userId: userId,
              bookId: userBooks.last.id,
            ),
          ).called(1);
          verify(
            () => bookRemoteDbService.deleteBook(
              userId: userId,
              bookId: userBooks.last.id,
            ),
          ).called(1);
        },
      );

      test(
        'device has not internet connection, should update each book in local db with sync state set as deleted',
        () async {
          device.mockHasDeviceInternetConnection(value: false);

          await repository.deleteAllUserBooks(userId: userId);

          verify(
            () => bookLocalDbService.updateBookData(
              bookId: userBooks.first.id,
              syncState: SyncState.deleted,
            ),
          ).called(1);
          verify(
            () => bookLocalDbService.updateBookData(
              bookId: userBooks.last.id,
              syncState: SyncState.deleted,
            ),
          ).called(1);
        },
      );
    },
  );
}
