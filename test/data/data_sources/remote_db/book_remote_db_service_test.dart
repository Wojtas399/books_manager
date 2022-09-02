import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_firestore_book_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:app/data/models/db_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestoreBookService extends Mock
    implements FirebaseFirestoreBookService {}

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {}

void main() {
  final firebaseFirestoreBookService = MockFirebaseFirestoreBookService();
  final firebaseStorageService = MockFirebaseStorageService();
  late BookRemoteDbService service;

  setUp(() {
    service = BookRemoteDbService(
      firebaseFirestoreBookService: firebaseFirestoreBookService,
      firebaseStorageService: firebaseStorageService,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreBookService);
    reset(firebaseStorageService);
  });

  test(
    'load books by user id, should return user books from firebase firestore with loaded images from firebase storage',
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
        () => firebaseFirestoreBookService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => dbBooks);
      when(
        () => firebaseStorageService.loadBookImageData(
          bookId: 'b1',
          userId: userId,
        ),
      ).thenAnswer((_) async => b1ImageData);
      when(
        () => firebaseStorageService.loadBookImageData(
          bookId: 'b2',
          userId: userId,
        ),
      ).thenAnswer((_) async => null);

      final List<DbBook> loadedDbBooks = await service.loadBooksByUserId(
        userId: userId,
      );

      expect(loadedDbBooks, expectedDbBooks);
    },
  );

  test(
    'add book, should only call method responsible for adding book to firebase firestore if book does not have image',
    () async {
      final DbBook dbBookToAdd = createDbBook(id: 'b1');
      when(
        () => firebaseFirestoreBookService.addBook(dbBook: dbBookToAdd),
      ).thenAnswer((_) async => '');

      await service.addBook(dbBook: dbBookToAdd);

      verify(
        () => firebaseFirestoreBookService.addBook(dbBook: dbBookToAdd),
      ).called(1);
    },
  );

  test(
    'add book, should call methods responsible for adding book to firebase firestore and for adding book to firebase storage if book has image',
    () async {
      final Uint8List imageData = Uint8List(10);
      const String userId = 'u1';
      const String addedBookId = 'b1';
      final DbBook dbBookToAdd = createDbBook(
        id: addedBookId,
        imageData: imageData,
        userId: userId,
      );
      when(
        () => firebaseFirestoreBookService.addBook(dbBook: dbBookToAdd),
      ).thenAnswer((_) async => '');
      when(
        () => firebaseStorageService.saveBookImageData(
          imageData: imageData,
          bookId: addedBookId,
          userId: userId,
        ),
      ).thenAnswer((_) async => '');

      await service.addBook(dbBook: dbBookToAdd);

      verify(
        () => firebaseFirestoreBookService.addBook(dbBook: dbBookToAdd),
      ).called(1);
      verify(
        () => firebaseStorageService.saveBookImageData(
          imageData: imageData,
          bookId: addedBookId,
          userId: userId,
        ),
      ).called(1);
    },
  );
}
