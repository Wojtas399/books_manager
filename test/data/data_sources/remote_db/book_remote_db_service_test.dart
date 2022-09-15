import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/book_remote_db_service.dart';
import 'package:app/data/data_sources/remote_db/firebase/models/firebase_book.dart';
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
    'load user books, should load user books data from firebase firestore and their images from firebase storage',
    () async {
      const String userId = 'u1';
      final Uint8List b1ImageData = Uint8List(10);
      final List<FirebaseBook> firebaseBooks = [
        createFirebaseBook(id: 'b1', userId: userId),
        createFirebaseBook(id: 'b2', userId: userId),
      ];
      final List<DbBook> expectedDbBooks = [
        createDbBook(id: 'b1', imageData: b1ImageData, userId: userId),
        createDbBook(id: 'b2', userId: userId),
      ];
      when(
        () => firebaseFirestoreBookService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => firebaseBooks);
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

      final List<DbBook> loadedDbBooks = await service.loadUserBooks(
        userId: userId,
      );

      expect(loadedDbBooks, expectedDbBooks);
    },
  );

  group(
    'add book',
    () {
      DbBook dbBook = createDbBook(id: 'b1');
      final FirebaseBook firebaseBook = createFirebaseBook(id: 'b1');

      setUp(() {
        when(
          () => firebaseFirestoreBookService.addBook(
            firebaseBook: firebaseBook,
          ),
        ).thenAnswer((_) async => '');
      });

      test(
        'should only call method responsible for adding book to firebase firestore if book does not have image',
        () async {
          await service.addBook(dbBook: dbBook);

          verify(
            () => firebaseFirestoreBookService.addBook(
              firebaseBook: firebaseBook,
            ),
          ).called(1);
        },
      );

      test(
        'should call methods responsible for adding book to firebase firestore and for adding book to firebase storage if book has image',
        () async {
          final Uint8List imageData = Uint8List(10);
          dbBook = dbBook.copyWith(imageData: imageData);
          when(
            () => firebaseStorageService.saveBookImageData(
              imageData: imageData,
              userId: dbBook.userId,
              bookId: dbBook.id,
            ),
          ).thenAnswer((_) async => '');

          await service.addBook(dbBook: dbBook);

          verify(
            () => firebaseFirestoreBookService.addBook(
              firebaseBook: firebaseBook,
            ),
          ).called(1);
          verify(
            () => firebaseStorageService.saveBookImageData(
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
    'update book data, should call method responsible for updating book in firebase firestore',
    () async {
      const String bookId = 'b1';
      const String userId = 'u1';
      const String newTitle = 'newTitle';
      const int newReadPagesAmount = 0;
      when(
        () => firebaseFirestoreBookService.updateBook(
          bookId: bookId,
          userId: userId,
          title: newTitle,
          readPagesAmount: newReadPagesAmount,
        ),
      ).thenAnswer((_) async => '');

      await service.updateBookData(
        bookId: bookId,
        userId: userId,
        title: newTitle,
        readPagesAmount: newReadPagesAmount,
      );

      verify(
        () => firebaseFirestoreBookService.updateBook(
          bookId: bookId,
          userId: userId,
          title: newTitle,
          readPagesAmount: newReadPagesAmount,
        ),
      ).called(1);
    },
  );

  group(
    'update book image',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';

      test(
        'should call method responsible for deleting existing book image from firebase storage if image is null',
        () async {
          when(
            () => firebaseStorageService.deleteBookImageData(
              userId: userId,
              bookId: bookId,
            ),
          ).thenAnswer((_) async => '');

          await service.updateBookImage(
            bookId: bookId,
            userId: userId,
            imageData: null,
          );

          verify(
            () => firebaseStorageService.deleteBookImageData(
              userId: userId,
              bookId: bookId,
            ),
          ).called(1);
        },
      );

      test(
        'should call method responsible for saving image to firebase storage if new image is not null',
        () async {
          final Uint8List imageData = Uint8List(1);
          when(
            () => firebaseStorageService.saveBookImageData(
              imageData: imageData,
              userId: userId,
              bookId: bookId,
            ),
          ).thenAnswer((_) async => '');

          await service.updateBookImage(
            bookId: bookId,
            userId: userId,
            imageData: imageData,
          );

          verify(
            () => firebaseStorageService.saveBookImageData(
              imageData: imageData,
              userId: userId,
              bookId: bookId,
            ),
          ).called(1);
        },
      );
    },
  );

  test(
    'delete book, should call methods responsible for deleting book from firebase firestore and for deleting book from firebase storage',
    () async {
      const String userId = 'u1';
      const String bookId = 'b1';
      when(
        () => firebaseFirestoreBookService.deleteBook(
          userId: userId,
          bookId: bookId,
        ),
      ).thenAnswer((_) async => '');
      when(
        () => firebaseStorageService.deleteBookImageData(
          userId: userId,
          bookId: bookId,
        ),
      ).thenAnswer((_) async => '');

      await service.deleteBook(userId: userId, bookId: bookId);

      verify(
        () => firebaseFirestoreBookService.deleteBook(
          userId: userId,
          bookId: bookId,
        ),
      ).called(1);
      verify(
        () => firebaseStorageService.deleteBookImageData(
          userId: userId,
          bookId: bookId,
        ),
      ).called(1);
    },
  );

  test(
    'delete book image, should call method responsible for deleting image from firebase storage',
    () async {
      const String userId = 'u1';
      const String bookId = 'b1';
      when(
        () => firebaseStorageService.deleteBookImageData(
          userId: userId,
          bookId: bookId,
        ),
      ).thenAnswer((_) async => '');

      await service.deleteBookImage(userId: userId, bookId: bookId);

      verify(
        () => firebaseStorageService.deleteBookImageData(
          userId: userId,
          bookId: bookId,
        ),
      ).called(1);
    },
  );
}
