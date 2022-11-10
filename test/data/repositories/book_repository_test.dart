import 'dart:typed_data';

import 'package:app/data/data_sources/firebase/entities/firebase_book.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/firebase/mock_firebase_firestore_book_service.dart';
import '../../mocks/firebase/mock_firebase_storage_image_service.dart';

class FakeImage extends Fake implements Image {}

void main() {
  final firebaseFirestoreBookService = MockFirebaseFirestoreBookService();
  final firebaseStorageImageService = MockFirebaseStorageImageService();
  late BookRepository repository;
  const String userId = 'u1';

  setUpAll(() {
    registerFallbackValue(FakeImage());
  });

  setUp(() {
    repository = BookRepository(
      firebaseFirestoreBookService: firebaseFirestoreBookService,
      firebaseStorageImageService: firebaseStorageImageService,
    );
  });

  tearDown(() {
    reset(firebaseFirestoreBookService);
    reset(firebaseStorageImageService);
  });

  test(
    'get book, should query for book from firebase firestore and for its image from firebase storage',
    () async {
      const String bookId = 'b1';
      const String imageFileName = 'i1.jpg';
      final Image image = createImage(
        fileName: imageFileName,
        data: Uint8List(2),
      );
      final FirebaseBook firebaseBook = createFirebaseBook(
        id: bookId,
        userId: userId,
        imageFileName: imageFileName,
      );
      final Book expectedBook = createBook(
        id: firebaseBook.id,
        userId: firebaseBook.userId,
        image: image,
      );
      firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);
      firebaseStorageImageService.mockLoadImage(imageData: image.data);

      final Stream<Book?> book$ = repository.getBook(
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
        () => firebaseStorageImageService.loadImage(
          fileName: imageFileName,
          userId: userId,
        ),
      ).called(1);
    },
  );

  group(
    'get user books',
    () {
      const String userId = 'u1';
      const String book1ImageFileName = 'i1.jpg';
      final Image book1Image = createImage(
        fileName: book1ImageFileName,
        data: Uint8List(2),
      );
      final List<FirebaseBook> userFirebaseBooks = [
        createFirebaseBook(
          id: 'b1',
          userId: userId,
          imageFileName: book1ImageFileName,
        ),
        createFirebaseBook(id: 'b2', userId: userId, imageFileName: null),
      ];
      final List<Book> expectedUserBooks = [
        createBook(
          id: userFirebaseBooks.first.id,
          userId: userFirebaseBooks.first.userId,
          image: book1Image,
        ),
        createBook(
          id: userFirebaseBooks.last.id,
          userId: userFirebaseBooks.last.userId,
          image: null,
        ),
      ];

      Stream<List<Book>> methodCall(BookStatus? bookStatus) {
        return repository.getUserBooks(userId: userId, bookStatus: bookStatus);
      }

      setUp(() {
        firebaseFirestoreBookService.mockGetUserBooks(
          userFirebaseBooks: userFirebaseBooks,
        );
        when(
          () => firebaseStorageImageService.loadImage(
            fileName: book1ImageFileName,
            userId: userId,
          ),
        ).thenAnswer((_) async => book1Image.data);
      });

      tearDown(() {
        verify(
          () => firebaseStorageImageService.loadImage(
            fileName: book1ImageFileName,
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
    'add new book',
    () {
      const String userId = 'u1';
      const BookStatus bookStatus = BookStatus.inProgress;
      final String bookStatusAsStr =
          BookStatusMapper.mapFromEnumToString(bookStatus);
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 20;
      const int allPagesAmount = 200;

      Future<void> methodCall(Image? image) async {
        await repository.addNewBook(
          userId: userId,
          status: bookStatus,
          image: image,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        );
      }

      setUp(() {
        firebaseFirestoreBookService.mockAddBook();
        firebaseStorageImageService.mockSaveImage();
      });

      test(
        'image is null, should only add book to firebase firestore',
        () async {
          await methodCall(null);

          verifyNever(
            () => firebaseStorageImageService.saveImage(
              image: any(named: 'image'),
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
        'image is not null, should add image to firebase storage and should add book to firebase firestore',
        () async {
          final Image image = createImage(
            fileName: 'i1.jpg',
            data: Uint8List(10),
          );

          await methodCall(image);

          verify(
            () => firebaseStorageImageService.saveImage(
              image: image,
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
              imageFileName: image.fileName,
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
      const BookStatus bookStatus = BookStatus.inProgress;
      final String bookStatusAsStr =
          BookStatusMapper.mapFromEnumToString(bookStatus);
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 40;
      const int allPagesAmount = 100;

      Future<void> methodCall(Image? image) async {
        await repository.updateBook(
          bookId: bookId,
          userId: userId,
          status: bookStatus,
          image: image,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        );
      }

      setUp(() {
        firebaseFirestoreBookService.mockUpdateBook();
      });

      test(
        'image file is null, should only update book in firebase firestore',
        () async {
          await methodCall(null);

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
        'image file is not null, book does not have image currently, should save new image in firebase storage and should update book in firebase firestore',
        () async {
          final Image image = createImage(
            fileName: 'i1.jpg',
            data: Uint8List(2),
          );
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            imageFileName: null,
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);
          firebaseStorageImageService.mockSaveImage();

          await methodCall(image);

          verify(
            () => firebaseStorageImageService.saveImage(
              image: image,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              status: bookStatusAsStr,
              imageFileName: image.fileName,
              title: title,
              author: author,
              readPagesAmount: readPagesAmount,
              allPagesAmount: allPagesAmount,
            ),
          ).called(1);
        },
      );

      test(
        'image file is not null, book has image currently, should delete current image from firebase storage, should save new image in firebase storage and should update book in firebase firestore',
        () async {
          final Image image = createImage(
            fileName: 'i1.jpg',
            data: Uint8List(2),
          );
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            imageFileName: 'i123.jpg',
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);
          firebaseStorageImageService.mockDeleteImage();
          firebaseStorageImageService.mockSaveImage();

          await methodCall(image);

          verify(
            () => firebaseStorageImageService.deleteImage(
              fileName: 'i123.jpg',
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseStorageImageService.saveImage(
              image: image,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              status: bookStatusAsStr,
              imageFileName: image.fileName,
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

      Future<void> methodCall() async {
        await repository.deleteBookImage(bookId: bookId, userId: userId);
      }

      setUp(() {
        firebaseStorageImageService.mockDeleteImage();
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
        'book does not have image, should do nothing',
        () async {
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            userId: userId,
            imageFileName: null,
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await methodCall();

          verifyNever(
            () => firebaseStorageImageService.deleteImage(
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
          verifyNever(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              deletedImageFileName: true,
            ),
          );
        },
      );

      test(
        'book has image, should delete book image from image data source and should update book in firebase firestore with deleted image file name set as null',
        () async {
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            userId: userId,
            imageFileName: 'i1.jpg',
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);
          firebaseFirestoreBookService.mockUpdateBook();

          await methodCall();

          verify(
            () => firebaseStorageImageService.deleteImage(
              fileName: 'i1.jpg',
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              deletedImageFileName: true,
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

      Future<void> methodCall() async {
        await repository.deleteBook(bookId: bookId, userId: userId);
      }

      setUp(() {
        firebaseStorageImageService.mockDeleteImage();
        firebaseFirestoreBookService.mockDeleteBook();
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
        'book does not exist, should do nothing',
        () async {
          firebaseFirestoreBookService.mockGetBook();

          await methodCall();

          verifyNever(
            () => firebaseStorageImageService.deleteImage(
              fileName: any(named: 'fileName'),
              userId: userId,
            ),
          );
          verifyNever(
            () => firebaseFirestoreBookService.deleteBook(
              userId: userId,
              bookId: bookId,
            ),
          );
        },
      );

      test(
        'book does not have image, should only delete book from firebase firestore',
        () async {
          final FirebaseBook firebaseBook = createFirebaseBook(
            id: bookId,
            userId: userId,
            imageFileName: null,
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await methodCall();

          verifyNever(
            () => firebaseStorageImageService.deleteImage(
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
            imageFileName: 'i1.jpg',
          );
          firebaseFirestoreBookService.mockGetBook(firebaseBook: firebaseBook);

          await methodCall();

          verify(
            () => firebaseStorageImageService.deleteImage(
              fileName: 'i1.jpg',
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

  test(
    'delete all user books, should delete all user books and their images',
    () async {
      const String userId = 'u1';
      final List<FirebaseBook> userFirebaseBooks = [
        createFirebaseBook(id: 'b1', userId: userId, imageFileName: 'i1.jpg'),
        createFirebaseBook(id: 'b2', userId: userId, imageFileName: null),
      ];
      firebaseFirestoreBookService.mockGetUserBooks(
        userFirebaseBooks: userFirebaseBooks,
      );
      firebaseStorageImageService.mockDeleteImage();
      firebaseFirestoreBookService.mockDeleteBook();

      await repository.deleteAllUserBooks(userId: userId);

      verify(
        () => firebaseFirestoreBookService.getUserBooks(userId: userId),
      ).called(1);
      verify(
        () => firebaseStorageImageService.deleteImage(
          fileName: 'i1.jpg',
          userId: userId,
        ),
      ).called(1);
      verify(
        () => firebaseFirestoreBookService.deleteBook(
          userId: userId,
          bookId: userFirebaseBooks.first.id,
        ),
      ).called(1);
      verify(
        () => firebaseFirestoreBookService.deleteBook(
          userId: userId,
          bookId: userFirebaseBooks.last.id,
        ),
      ).called(1);
    },
  );
}
