import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/services/fire_book_service.dart';
import 'package:app/data/data_sources/remote_db/services/book_remote_db_service.dart';
import 'package:app/data/models/db_book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseBookService extends Mock implements FirebaseBookService {}

void main() {
  final firebaseBookService = MockFirebaseBookService();
  late BookRemoteDbService service;

  setUp(() {
    service = BookRemoteDbService(firebaseBookService: firebaseBookService);
  });

  tearDown(() {
    reset(firebaseBookService);
  });

  test(
    'load books by user id, should return user books from firebase with loaded images',
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
        () => firebaseBookService.loadBooksByUserId(userId: userId),
      ).thenAnswer((_) async => dbBooks);
      when(
        () => firebaseBookService.loadBookImageData(
          bookId: 'b1',
          userId: userId,
        ),
      ).thenAnswer((_) async => b1ImageData);
      when(
        () => firebaseBookService.loadBookImageData(
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
    'add book, should call method from firebase book service responsible for adding new book',
    () async {
      final DbBook dbBookToAdd = createDbBook(id: 'b1');
      when(
        () => firebaseBookService.addBook(dbBook: dbBookToAdd),
      ).thenAnswer((_) async => '');

      await service.addBook(dbBook: dbBookToAdd);

      verify(
        () => firebaseBookService.addBook(dbBook: dbBookToAdd),
      ).called(1);
    },
  );
}
