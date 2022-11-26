import 'dart:typed_data';

import 'package:app/data/firebase/entities/firebase_book.dart';
import 'package:app/data/firebase/entities/firebase_doc_change.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/data/repositories/book_repository.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  BookRepository createRepository({
    List<Book>? books,
  }) {
    return BookRepository(
      initialData: books,
      firebaseFirestoreBookService: firebaseFirestoreBookService,
      firebaseStorageImageService: firebaseStorageImageService,
    );
  }

  setUpAll(() {
    registerFallbackValue(FakeImage());
  });

  setUp(() {
    repository = createRepository();
  });

  tearDown(() {
    reset(firebaseFirestoreBookService);
    reset(firebaseStorageImageService);
  });

  group(
    'initialize books of user',
    () {
      void methodCall() {
        repository.initializeBooksOfUser(userId: userId);
      }

      Stream<List<Book>?> getBooksOfUser() {
        return repository.getBooksOfUser(userId: userId);
      }

      tearDown(() {
        verify(
          () => firebaseFirestoreBookService.getDocChangesOfAllBooksOfUser(
            userId: userId,
          ),
        ).called(1);
      });

      test(
        'book has been added, should load image for this book and should add this book with loaded image to repository state',
        () async {
          final Image bookImage = createImage(
            fileName: 'i1.jpg',
            data: Uint8List(2),
          );
          final List<FirebaseDocChange<FirebaseBook>> docChanges = [
            createFirebaseDocChange(
              docChangeType: DocumentChangeType.added,
              doc: createFirebaseBook(
                id: 'b1',
                userId: userId,
                imageFileName: bookImage.fileName,
              ),
            ),
          ];
          final Book expectedAddedBook = createBook(
            id: 'b1',
            userId: userId,
            image: bookImage,
          );
          firebaseFirestoreBookService.mockGetDocChangesOfAllBooksOfUser(
            docChanges: docChanges,
          );
          firebaseStorageImageService.mockLoadImage(imageData: bookImage.data);

          methodCall();
          await Future.delayed(const Duration(seconds: 1));
          final Stream<List<Book>?> allUserBooks$ = getBooksOfUser();

          verify(
            () => firebaseStorageImageService.loadImage(
              fileName: bookImage.fileName,
              userId: userId,
            ),
          ).called(1);
          expect(await allUserBooks$.first, [expectedAddedBook]);
        },
      );

      test(
        'book has been modified, should load image for this book and should change this book with loaded image in repository state',
        () async {
          final Image bookImage = createImage(
            fileName: 'i1.jpg',
            data: Uint8List(2),
          );
          final List<FirebaseDocChange<FirebaseBook>> docChanges = [
            createFirebaseDocChange(
              docChangeType: DocumentChangeType.modified,
              doc: createFirebaseBook(
                id: 'b1',
                userId: userId,
                imageFileName: bookImage.fileName,
              ),
            ),
          ];
          final Book existingBook = createBook(
            id: 'b1',
            userId: userId,
            image: null,
          );
          final Book expectedUpdatedBook = existingBook.copyWith(
            image: bookImage,
          );
          repository = createRepository(books: [existingBook]);
          firebaseFirestoreBookService.mockGetDocChangesOfAllBooksOfUser(
            docChanges: docChanges,
          );
          firebaseStorageImageService.mockLoadImage(imageData: bookImage.data);

          methodCall();
          await Future.delayed(const Duration(seconds: 1));
          final Stream<List<Book>?> allUserBooks$ = getBooksOfUser();

          verify(
            () => firebaseStorageImageService.loadImage(
              fileName: bookImage.fileName,
              userId: userId,
            ),
          ).called(1);
          expect(await allUserBooks$.first, [expectedUpdatedBook]);
        },
      );

      test(
        'book has been removed, should remove this book from repository state',
        () async {
          final List<FirebaseDocChange<FirebaseBook>> docChanges = [
            createFirebaseDocChange(
              docChangeType: DocumentChangeType.removed,
              doc: createFirebaseBook(id: 'b1', userId: userId),
            ),
          ];
          final Book existingBook = createBook(id: 'b1', userId: userId);
          repository = createRepository(books: [existingBook]);
          firebaseFirestoreBookService.mockGetDocChangesOfAllBooksOfUser(
            docChanges: docChanges,
          );

          methodCall();
          await Future.delayed(const Duration(seconds: 1));
          final Stream<List<Book>?> allUserBooks$ = getBooksOfUser();

          expect(await allUserBooks$.first, []);
        },
      );
    },
  );

  test(
    'get book, should return stream with user book matching to given book id',
    () async {
      const String bookId = 'b1';
      final List<Book> existingBooks = [
        createBook(id: bookId, userId: userId),
        createBook(id: 'b2', userId: userId),
        createBook(id: 'b1', userId: 'u2'),
      ];
      final Book expectedBook = existingBooks.first;
      repository = createRepository(books: existingBooks);

      final Stream<Book?> book$ = repository.getBook(
        bookId: bookId,
        userId: userId,
      );

      expect(await book$.first, expectedBook);
    },
  );

  group(
    'get books of user',
    () {
      final List<Book> existingBooks = [
        createBook(id: 'b1', userId: userId, status: BookStatus.inProgress),
        createBook(id: 'b2', userId: userId, status: BookStatus.finished),
        createBook(id: 'b3', userId: userId, status: BookStatus.inProgress),
        createBook(id: 'b1', userId: 'u12', status: BookStatus.finished),
      ];

      Stream<List<Book>?> methodCall(BookStatus? bookStatus) {
        return repository.getBooksOfUser(
          userId: userId,
          bookStatus: bookStatus,
        );
      }

      setUp(() {
        repository = createRepository(books: existingBooks);
      });

      test(
        'book status is null, should return stream with all user books',
        () async {
          const BookStatus? bookStatus = null;
          final List<Book> expectedBooks =
              existingBooks.getRange(0, 3).toList();

          final Stream<List<Book>?> userBooks$ = methodCall(bookStatus);

          expect(await userBooks$.first, expectedBooks);
        },
      );

      test(
        'book status is not null, should return stream with user books matching to given book status',
        () async {
          const BookStatus bookStatus = BookStatus.inProgress;
          final List<Book> expectedBooks = [
            existingBooks.first,
            existingBooks[2],
          ];

          final Stream<List<Book>?> userBooks$ = methodCall(bookStatus);

          expect(await userBooks$.first, expectedBooks);
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
          firebaseFirestoreBookService.mockLoadBookImageFileName();
          firebaseStorageImageService.mockSaveImage();

          await methodCall(image);

          verify(
            () => firebaseFirestoreBookService.loadBookImageFileName(
              bookId: bookId,
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

      test(
        'image file is not null, book has image currently, should delete current image from firebase storage, should save new image in firebase storage and should update book in firebase firestore',
        () async {
          const String currentImageFileName = 'i123.jpg';
          final Image newImage = createImage(
            fileName: 'i1.jpg',
            data: Uint8List(2),
          );
          firebaseFirestoreBookService.mockLoadBookImageFileName(
            bookImageFileName: currentImageFileName,
          );
          firebaseStorageImageService.mockDeleteImage();
          firebaseStorageImageService.mockSaveImage();

          await methodCall(newImage);

          verify(
            () => firebaseFirestoreBookService.loadBookImageFileName(
              bookId: bookId,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseStorageImageService.deleteImage(
              fileName: currentImageFileName,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseStorageImageService.saveImage(
              image: newImage,
              userId: userId,
            ),
          ).called(1);
          verify(
            () => firebaseFirestoreBookService.updateBook(
              bookId: bookId,
              userId: userId,
              status: bookStatusAsStr,
              imageFileName: newImage.fileName,
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
          () => firebaseFirestoreBookService.loadBookImageFileName(
            bookId: bookId,
            userId: userId,
          ),
        ).called(1);
      });

      test(
        'book does not have image, should do nothing',
        () async {
          firebaseFirestoreBookService.mockLoadBookImageFileName();

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
          const String bookImageFileName = 'i1.jpg';
          firebaseFirestoreBookService.mockLoadBookImageFileName(
            bookImageFileName: bookImageFileName,
          );
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
          () => firebaseFirestoreBookService.loadBookImageFileName(
            bookId: bookId,
            userId: userId,
          ),
        ).called(1);
      });

      test(
        'book does not have image, should only call method from firebase firestore responsible for deleting book',
        () async {
          firebaseFirestoreBookService.mockLoadBookImageFileName();

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
        'book has image, should call methods from firebase firestore and firebase storage responsible for deleting book and its image',
        () async {
          const String bookImageFileName = 'i1.jpg';
          firebaseFirestoreBookService.mockLoadBookImageFileName(
            bookImageFileName: bookImageFileName,
          );

          await methodCall();

          verify(
            () => firebaseStorageImageService.deleteImage(
              fileName: bookImageFileName,
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
    'delete books of user, should call methods responsible for deleting all user books and their images',
    () async {
      firebaseFirestoreBookService.mockDeleteAllBooksOfUser();
      firebaseStorageImageService.mockDeleteAllUserImages();

      await repository.deleteAllBooksOfUser(userId: userId);

      verify(
        () => firebaseFirestoreBookService.deleteAllBooksOfUser(
          userId: userId,
        ),
      ).called(1);
      verify(
        () => firebaseStorageImageService.deleteAllUserImages(
          userId: userId,
        ),
      ).called(1);
    },
  );
}
