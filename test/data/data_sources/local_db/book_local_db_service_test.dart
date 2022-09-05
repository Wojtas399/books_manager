import 'dart:typed_data';

import 'package:app/data/data_sources/local_db/book_local_db_service.dart';
import 'package:app/data/data_sources/local_db/local_storage_service.dart';
import 'package:app/data/data_sources/local_db/sqlite/services/sqlite_book_service.dart';
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
    'load user books, should return user books from sqlite with loaded images from local storage',
    () async {
      const String userId = 'u1';
      final Uint8List b1ImageData = Uint8List(20);
      final List<DbBook> dbBooks = [
        createDbBook(id: 'b1', userId: userId),
        createDbBook(id: 'b2', userId: userId),
      ];
      final List<DbBook> expectedDbBooks = [
        dbBooks[0].copyWith(imageData: b1ImageData),
        dbBooks[1],
      ];
      when(
        () => sqliteBookService.loadUserBooks(userId: userId),
      ).thenAnswer((_) async => dbBooks);
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

      final List<DbBook> loadedDbBooks = await service.loadUserBooks(
        userId: userId,
      );

      expect(loadedDbBooks, expectedDbBooks);
    },
  );

  test(
    'load ids of user books marked as deleted, should return result of method responsible for loading ids of user books marked as deleted',
    () async {
      const String userId = 'u1';
      const List<String> expectedIdsOfBooksMarkedAsDeleted = ['b2', 'b3'];
      when(
        () => sqliteBookService.loadIdsOfUserBooksMarkedAsDeleted(
          userId: userId,
        ),
      ).thenAnswer((_) async => expectedIdsOfBooksMarkedAsDeleted);

      final List<String> idsOfBooksMarkedAsDeleted =
          await service.loadIdsOfUserBooksMarkedAsDeleted(userId: userId);

      expect(
        idsOfBooksMarkedAsDeleted,
        expectedIdsOfBooksMarkedAsDeleted,
      );
    },
  );

  test(
    'add book, should only call method responsible for adding book to sqlite if book does not have image',
    () async {
      final DbBook dbBookToAdd = createDbBook();
      final DbBook expectedAddedDbBook = dbBookToAdd.copyWith(id: 'b1');
      when(
        () => sqliteBookService.addBook(dbBook: dbBookToAdd),
      ).thenAnswer((_) async => expectedAddedDbBook);

      final DbBook addedDbBook = await service.addBook(dbBook: dbBookToAdd);

      verify(
        () => sqliteBookService.addBook(dbBook: dbBookToAdd),
      ).called(1);
      expect(addedDbBook, expectedAddedDbBook);
    },
  );

  test(
    'add book, should call methods responsible for adding book to sqlite and for adding book image to local storage if book has image',
    () async {
      final Uint8List imageData = Uint8List(10);
      const String userId = 'u1';
      const String addedBookId = 'b1';
      final DbBook dbBookToAdd = createDbBook(
        imageData: imageData,
        userId: userId,
      );
      final DbBook expectedAddedDbBook = dbBookToAdd.copyWith(id: addedBookId);
      when(
        () => sqliteBookService.addBook(dbBook: dbBookToAdd),
      ).thenAnswer((_) async => expectedAddedDbBook);
      when(
        () => localStorageService.saveBookImageData(
          imageData: imageData,
          bookId: addedBookId,
          userId: userId,
        ),
      ).thenAnswer((_) async => '');

      final DbBook addedDbBook = await service.addBook(dbBook: dbBookToAdd);

      verify(
        () => sqliteBookService.addBook(dbBook: dbBookToAdd),
      ).called(1);
      verify(
        () => localStorageService.saveBookImageData(
          imageData: imageData,
          bookId: addedBookId,
          userId: userId,
        ),
      ).called(1);
      expect(addedDbBook, expectedAddedDbBook);
    },
  );

  test(
    'mark book as deleted, should call method responsible for marking book as deleted',
    () async {
      const String bookId = 'b1';
      when(
        () => sqliteBookService.markBookAsDeleted(bookId: bookId),
      ).thenAnswer((_) async => '');

      await service.markBookAsDeleted(bookId: bookId);

      verify(
        () => sqliteBookService.markBookAsDeleted(bookId: bookId),
      ).called(1);
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
