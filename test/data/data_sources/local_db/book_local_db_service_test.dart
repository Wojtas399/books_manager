import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/models/sqlite_book.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/models/db_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSqliteBookService extends Mock implements SqliteBookService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  final sqliteBookService = MockSqliteBookService();
  final localStorageService = MockLocalStorageService();
  late BookLocalDbService service;

  setUp(() {
    service = BookLocalDbService(
      sqliteBookService: sqliteBookService,
      localStorageService: localStorageService,
    );
  });

  tearDown(() {
    reset(sqliteBookService);
    reset(localStorageService);
  });

  test(
    'load user books, should load user books data from sqlite and their images from local storage',
    () async {
      const String userId = 'u1';
      const SyncState syncState = SyncState.added;
      final Uint8List b1ImageData = Uint8List(20);
      final List<SqliteBook> sqliteBooks = [
        createSqliteBook(id: 'b1', userId: userId),
        createSqliteBook(id: 'b2', userId: userId),
      ];
      final List<DbBook> expectedDbBooks = [
        createDbBook(id: 'b1', imageData: b1ImageData, userId: userId),
        createDbBook(id: 'b2', userId: userId),
      ];
      when(
        () => sqliteBookService.loadUserBooks(
          userId: userId,
          syncState: syncState,
        ),
      ).thenAnswer((_) async => sqliteBooks);
      when(
        () => localStorageService.loadBookImageData(
          bookId: 'b1',
          userId: userId,
        ),
      ).thenAnswer((_) async => b1ImageData);
      when(
        () => localStorageService.loadBookImageData(
          bookId: 'b2',
          userId: userId,
        ),
      ).thenAnswer((_) async => null);

      final List<DbBook> loadedDbBooks =
          await service.loadUserBooks(userId: userId, syncState: syncState);

      expect(loadedDbBooks, expectedDbBooks);
    },
  );

  group(
    'add book',
    () {
      const SyncState syncState = SyncState.none;
      DbBook dbBook = createDbBook(id: 'b1');
      final SqliteBook sqliteBook = createSqliteBook(
        id: 'b1',
        syncState: syncState,
      );

      setUp(() {
        when(
          () => sqliteBookService.addBook(sqliteBook: sqliteBook),
        ).thenAnswer((_) async => sqliteBook);
      });

      test(
        'should only call method responsible for adding book to sqlite if book does not have image',
        () async {
          await service.addBook(dbBook: dbBook, syncState: syncState);

          verify(
            () => sqliteBookService.addBook(sqliteBook: sqliteBook),
          ).called(1);
        },
      );

      test(
        'should call methods responsible for adding book to sqlite and for adding book image to local storage if book has image',
        () async {
          final Uint8List imageData = Uint8List(10);
          dbBook = dbBook.copyWith(imageData: imageData);
          when(
            () => localStorageService.saveBookImageData(
              imageData: imageData,
              userId: dbBook.userId,
              bookId: dbBook.id,
            ),
          ).thenAnswer((_) async => '');

          await service.addBook(dbBook: dbBook, syncState: syncState);

          verify(
            () => sqliteBookService.addBook(sqliteBook: sqliteBook),
          ).called(1);
          verify(
            () => localStorageService.saveBookImageData(
              imageData: imageData,
              userId: dbBook.userId,
              bookId: dbBook.id,
            ),
          ).called(1);
        },
      );
    },
  );

  test(
    'updated book data, should call method responsible for updating book in sqlite and should return updated book with its image',
    () async {
      const String bookId = 'b1';
      const String userId = 'u1';
      const String newTitle = 'newTitle';
      const int newReadPagesAmount = 30;
      final SqliteBook updatedSqliteBook = createSqliteBook(
        id: bookId,
        userId: userId,
        title: newTitle,
        readPagesAmount: newReadPagesAmount,
      );
      final Uint8List imageData = Uint8List(5);
      final DbBook expectedUpdatedBook = createDbBook(
        id: bookId,
        imageData: imageData,
        userId: userId,
        title: newTitle,
        readPagesAmount: newReadPagesAmount,
      );
      when(
        () => sqliteBookService.updateBook(
          bookId: bookId,
          title: newTitle,
          readPagesAmount: newReadPagesAmount,
        ),
      ).thenAnswer((_) async => updatedSqliteBook);
      when(
        () => localStorageService.loadBookImageData(
          userId: userId,
          bookId: bookId,
        ),
      ).thenAnswer((_) async => imageData);

      final DbBook updatedBook = await service.updateBookData(
        bookId: bookId,
        title: newTitle,
        readPagesAmount: newReadPagesAmount,
      );

      verify(
        () => sqliteBookService.updateBook(
          bookId: bookId,
          title: newTitle,
          readPagesAmount: newReadPagesAmount,
        ),
      ).called(1);
      expect(updatedBook, expectedUpdatedBook);
    },
  );

  group(
    'update book image',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';
      final SqliteBook sqliteBook = createSqliteBook(
        id: bookId,
        userId: userId,
      );

      setUp(() {
        when(
          () => sqliteBookService.loadBook(bookId: bookId),
        ).thenAnswer((_) async => sqliteBook);
      });

      test(
        'should call method responsible for deleting existing book image from local storage if new image is null and should return updated db book',
        () async {
          final DbBook expectedDbBook = createDbBook(
            id: bookId,
            userId: userId,
          );
          when(
            () => localStorageService.deleteBookImageData(
              userId: userId,
              bookId: bookId,
            ),
          ).thenAnswer((_) async => '');

          final DbBook updatedDbBook = await service.updateBookImage(
            bookId: bookId,
            userId: userId,
            imageData: null,
          );

          verify(
            () => localStorageService.deleteBookImageData(
              userId: userId,
              bookId: bookId,
            ),
          ).called(1);
          expect(updatedDbBook, expectedDbBook);
        },
      );

      test(
        'should call method responsible for saving image to local storage if new image is not null',
        () async {
          final Uint8List imageData = Uint8List(10);
          final DbBook expectedDbBook = createDbBook(
            id: bookId,
            userId: userId,
            imageData: imageData,
          );
          when(
            () => localStorageService.saveBookImageData(
              imageData: imageData,
              userId: userId,
              bookId: bookId,
            ),
          ).thenAnswer((_) async => '');

          final DbBook updatedDbBook = await service.updateBookImage(
            bookId: bookId,
            userId: userId,
            imageData: imageData,
          );

          verify(
            () => localStorageService.saveBookImageData(
              imageData: imageData,
              userId: userId,
              bookId: bookId,
            ),
          ).called(1);
          expect(updatedDbBook, expectedDbBook);
        },
      );
    },
  );

  test(
    'delete book, should call methods responsible for deleting book from sqlite and for deleting book image from local storage',
    () async {
      const String userId = 'u1';
      const String bookId = 'b1';
      when(
        () => sqliteBookService.deleteBook(bookId: bookId),
      ).thenAnswer((_) async => '');
      when(
        () => localStorageService.deleteBookImageData(
          bookId: bookId,
          userId: userId,
        ),
      ).thenAnswer((_) async => '');

      await service.deleteBook(userId: userId, bookId: bookId);

      verify(
        () => sqliteBookService.deleteBook(bookId: bookId),
      ).called(1);
      verify(
        () => localStorageService.deleteBookImageData(
          bookId: bookId,
          userId: userId,
        ),
      ).called(1);
    },
  );
}
