import 'dart:typed_data';

import 'package:app/data/data_sources/book_data_source.dart';
import 'package:app/data/data_sources/firebase/entities/firebase_book.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/image_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/data_sources/firebase/mock_firebase_storage_service.dart';
import '../../mocks/data/remote_db/firebase/mock_firebase_firestore_book_service.dart';

void main() {
  final firebaseFirestoreBookService = MockFirebaseFirestoreBookService();
  final firebaseStorageService = MockFirebaseStorageService();
  late BookDataSource dataSource;

  setUp(() {
    dataSource = BookDataSource(
      firebaseFirestoreBookService: firebaseFirestoreBookService,
      firebaseStorageService: firebaseStorageService,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreBookService);
    reset(firebaseStorageService);
  });

  test(
    'get book, should query for book with bookId and userId',
    () async {
      const String bookId = 'b1';
      const String userId = 'u1';
      final Uint8List imageData = Uint8List(10);
      final FirebaseBook firebaseBook = createFirebaseBook(
        id: bookId,
        userId: userId,
        imageFileName: 'i1',
      );
      final Book expectedBook = createBook(
        id: firebaseBook.id,
        userId: firebaseBook.userId,
        imageFile: createImageFile(name: 'i1', data: imageData),
      );
      firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);
      firebaseStorageService.mockLoadBookImageData(imageData: imageData);

      final Stream<Book?> book$ = dataSource.getBook(
        bookId: bookId,
        userId: userId,
      );

      expect(await book$.first, expectedBook);
      verify(
        () => firebaseFirestoreBookService.getBook(
          bookId: bookId,
          userId: userId,
        ),
      ).called(1);
      verify(
        () => firebaseStorageService.loadBookImageData(
          fileName: 'i1',
          userId: userId,
        ),
      ).called(1);
    },
  );

  group(
    'get user books',
    () {
      const String userId = 'u1';
      final Uint8List book1ImageData = Uint8List(10);
      final List<FirebaseBook> userFirebaseBooks = [
        createFirebaseBook(id: 'b1', userId: userId, imageFileName: 'i1'),
        createFirebaseBook(id: 'b2', userId: userId, imageFileName: 'i2'),
      ];
      final List<Book> expectedUserBooks = [
        createBook(
          id: userFirebaseBooks.first.id,
          userId: userFirebaseBooks.first.userId,
          imageFile: createImageFile(name: 'i1', data: book1ImageData),
        ),
        createBook(
          id: userFirebaseBooks.last.id,
          userId: userFirebaseBooks.last.userId,
        ),
      ];

      Stream<List<Book>> methodCall(BookStatus? bookStatus) {
        return dataSource.getUserBooks(userId: userId, bookStatus: bookStatus);
      }

      setUp(() {
        firebaseFirestoreBookService.mockGetUserBooks(
          userFirebaseBooks: userFirebaseBooks,
        );
        when(
          () => firebaseStorageService.loadBookImageData(
            fileName: 'i1',
            userId: userId,
          ),
        ).thenAnswer((_) async => book1ImageData);
        when(
          () => firebaseStorageService.loadBookImageData(
            fileName: 'i2',
            userId: userId,
          ),
        ).thenAnswer((_) async => null);
      });

      tearDown(() {
        verify(
          () => firebaseStorageService.loadBookImageData(
            fileName: 'i1',
            userId: userId,
          ),
        ).called(1);
        verify(
          () => firebaseStorageService.loadBookImageData(
            fileName: 'i2',
            userId: userId,
          ),
        ).called(1);
      });

      test(
        'book status is null, should query for user books with book status set as null',
        () async {
          const BookStatus? bookStatus = null;

          final Stream<List<Book>> userBooks$ = methodCall(bookStatus);

          expect(await userBooks$.first, expectedUserBooks);
          verify(
            () => firebaseFirestoreBookService.getUserBooks(
              userId: userId,
              bookStatus: null,
            ),
          ).called(1);
        },
      );

      test(
        'book status is not null, should query for user books with book status set as mapped given book status',
        () async {
          const BookStatus bookStatus = BookStatus.inProgress;
          final String bookStatusAsStr =
              BookStatusMapper.mapFromEnumToString(bookStatus);

          final Stream<List<Book>> userBooks$ = methodCall(bookStatus);

          expect(await userBooks$.first, expectedUserBooks);
          verify(
            () => firebaseFirestoreBookService.getUserBooks(
              userId: userId,
              bookStatus: bookStatusAsStr,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'add book',
    () {
      const String userId = 'u1';
      const BookStatus bookStatus = BookStatus.inProgress;
      final String bookStatusAsStr =
          BookStatusMapper.mapFromEnumToString(bookStatus);
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 20;
      const int allPagesAmount = 200;

      Future<void> methodCall(ImageFile? imageFile) async {
        await dataSource.addBook(
          userId: userId,
          status: bookStatus,
          imageFile: imageFile,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        );
      }

      setUp(() {
        firebaseFirestoreBookService.mockAddBook();
        firebaseStorageService.mockSaveBookImageData();
      });

      test(
        'image file is null, should only add book to firebase firestore',
        () async {
          await methodCall(null);

          verifyNever(
            () => firebaseStorageService.saveBookImageData(
              imageData: any(named: 'imageData'),
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
          verify(
            () => firebaseFirestoreBookService.addBook(
              userId: userId,
              status: bookStatusAsStr,
              title: title,
              author: author,
              readPagesAmount: readPagesAmount,
              allPagesAmount: allPagesAmount,
              imageFileName: null,
            ),
          ).called(1);
        },
      );

      test(
        'image file is not null, should add image to firebase storage and should add book too firebase firestore',
        () async {
          final ImageFile imageFile = createImageFile(
            name: 'i1',
            data: Uint8List(10),
          );

          await methodCall(imageFile);

          verify(
            () => firebaseStorageService.saveBookImageData(
              imageData: imageFile.data,
              fileName: imageFile.name,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.addBook(
              userId: userId,
              status: bookStatusAsStr,
              title: title,
              author: author,
              readPagesAmount: readPagesAmount,
              allPagesAmount: allPagesAmount,
              imageFileName: imageFile.name,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'update book',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';
      const BookStatus bookStatus = BookStatus.inProgress;
      final String bookStatusAsStr =
          BookStatusMapper.mapFromEnumToString(bookStatus);
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 40;
      const int allPagesAmount = 100;

      Future<void> methodCall(ImageFile? imageFile) async {
        await dataSource.updateBook(
          bookId: bookId,
          userId: userId,
          status: bookStatus,
          imageFile: imageFile,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        );
      }

      setUp(() {
        firebaseStorageService.mockDeleteBookImageData();
        firebaseStorageService.mockSaveBookImageData();
        firebaseFirestoreBookService.mockUpdateBook();
      });

      test(
        'image file is null, should only update book in firebase firestore',
        () async {
          await methodCall(null);

          verifyNever(
            () => firebaseStorageService.deleteBookImageData(
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
          verifyNever(
            () => firebaseStorageService.saveBookImageData(
              imageData: any(named: 'imageData'),
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
          verify(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              status: bookStatusAsStr,
              imageFileName: null,
              title: title,
              author: author,
              readPagesAmount: readPagesAmount,
              allPagesAmount: allPagesAmount,
            ),
          ).called(1);
        },
      );

      test(
        'image file is not null, book does not have image currently, should save new image to firebase storage and should update book in firebase firestore',
        () async {
          final Uint8List imageData = Uint8List(10);
          final ImageFile imageFile = createImageFile(
            name: 'i1',
            data: imageData,
          );
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            imageFileName: null,
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await methodCall(imageFile);

          verifyNever(
            () => firebaseStorageService.deleteBookImageData(
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
          verify(
            () => firebaseStorageService.saveBookImageData(
              imageData: imageData,
              fileName: imageFile.name,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              status: bookStatusAsStr,
              imageFileName: imageFile.name,
              title: title,
              author: author,
              readPagesAmount: readPagesAmount,
              allPagesAmount: allPagesAmount,
            ),
          ).called(1);
        },
      );

      test(
        'image file is not null, book has image currently, should delete current image from firebase storage, should save new image to firebase storage and should update book in firebase firestore',
        () async {
          final Uint8List imageData = Uint8List(10);
          final ImageFile imageFile = createImageFile(
            name: 'i1',
            data: imageData,
          );
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            imageFileName: 'i123',
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await methodCall(imageFile);

          verify(
            () => firebaseStorageService.deleteBookImageData(
              fileName: 'i123',
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseStorageService.saveBookImageData(
              imageData: imageData,
              fileName: imageFile.name,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              status: bookStatusAsStr,
              imageFileName: imageFile.name,
              title: title,
              author: author,
              readPagesAmount: readPagesAmount,
              allPagesAmount: allPagesAmount,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'delete book image',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';

      setUp(() {
        firebaseStorageService.mockDeleteBookImageData();
      });

      tearDown(() {
        verify(
          () => firebaseFirestoreBookService.getBook(
            bookId: bookId,
            userId: userId,
          ),
        ).called(1);
      });

      test(
        'book does not have image, should not call method responsible for deleting book image from firebase storage',
        () async {
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            userId: userId,
            imageFileName: null,
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await dataSource.deleteBookImage(bookId: bookId, userId: userId);

          verifyNever(
            () => firebaseStorageService.deleteBookImageData(
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
        },
      );

      test(
        'book has image, should delete book image from firebase storage',
        () async {
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            userId: userId,
            imageFileName: 'i1',
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await dataSource.deleteBookImage(bookId: bookId, userId: userId);

          verify(
            () => firebaseStorageService.deleteBookImageData(
              fileName: 'i1',
              userId: userId,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'delete book',
    () {
      const String bookId = 'b1';
      const String userId = 'u1';

      setUp(() {
        firebaseStorageService.mockDeleteBookImageData();
        firebaseFirestoreBookService.mockDeleteBook();
      });

      test(
        'book does not have image, should only delete book from firebase firestore',
        () async {
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            userId: userId,
            imageFileName: null,
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await dataSource.deleteBook(bookId: bookId, userId: userId);

          verifyNever(
            () => firebaseStorageService.deleteBookImageData(
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
          verify(
            () => firebaseFirestoreBookService.deleteBook(
              userId: userId,
              bookId: bookId,
            ),
          ).called(1);
        },
      );

      test(
        'book has image, should delete book image from firebase storage and should delete book from firebase firestore',
        () async {
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            userId: userId,
            imageFileName: 'i1',
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await dataSource.deleteBook(bookId: bookId, userId: userId);

          verify(
            () => firebaseStorageService.deleteBookImageData(
              fileName: 'i1',
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.deleteBook(
              userId: userId,
              bookId: bookId,
            ),
          ).called(1);
        },
      );
    },
  );
}
