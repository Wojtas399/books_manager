import 'package:app/data/repositories/book_repository.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/models/image_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/data_sources/mock_book_data_source.dart';

void main() {
  final bookDataSource = MockBookDataSource();
  late BookRepository repository;
  const String userId = 'u1';

  setUp(() {
    repository = BookRepository(bookDataSource: bookDataSource);
  });

  tearDown(() {
    reset(bookDataSource);
  });

  test(
    'get book, should return stream with book using method from data source responsible for getting book',
    () async {
      const String bookId = 'b1';
      final Book expectedBook = createBook(
        id: bookId,
        userId: userId,
        status: BookStatus.finished,
      );
      bookDataSource.mockGetBook(book: expectedBook);

      final Stream<Book?> book$ = repository.getBook(
        bookId: bookId,
        userId: userId,
      );

      expect(await book$.first, expectedBook);
      verify(
        () => bookDataSource.getBook(
          bookId: bookId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'get user books, should return stream with user books using method from data source responsible for getting user books',
    () async {
      const BookStatus bookStatus = BookStatus.unread;
      final List<Book> expectedBooks = [
        createBook(id: 'b1', userId: userId, status: bookStatus),
        createBook(id: 'b3', userId: userId, status: bookStatus),
      ];
      bookDataSource.mockGetUserBooks(userBooks: expectedBooks);

      final Stream<List<Book>?> userBooks$ = repository.getUserBooks(
        userId: userId,
        bookStatus: bookStatus,
      );

      expect(await userBooks$.first, expectedBooks);
      verify(
        () => bookDataSource.getUserBooks(
          userId: userId,
          bookStatus: bookStatus,
        ),
      ).called(1);
    },
  );

  test(
    'add new book, should call method from data source responsible for adding book',
    () async {
      const BookStatus status = BookStatus.inProgress;
      final ImageFile imageFile = createImageFile(name: 'i1');
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 20;
      const int allPagesAmount = 200;
      bookDataSource.mockAddBook();

      await repository.addNewBook(
        userId: userId,
        status: status,
        imageFile: imageFile,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );

      verify(
        () => bookDataSource.addBook(
          userId: userId,
          status: status,
          imageFile: imageFile,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        ),
      ).called(1);
    },
  );

  test(
    'update book, should call method from data source responsible for updating book',
    () async {
      const String bookId = 'b1';
      const BookStatus status = BookStatus.finished;
      final ImageFile imageFile = createImageFile(name: 'i1');
      const String title = 'title';
      const String author = 'author';
      const int readPagesAmount = 20;
      const int allPagesAmount = 200;
      bookDataSource.mockUpdateBook();

      await repository.updateBook(
        bookId: bookId,
        userId: userId,
        status: status,
        imageFile: imageFile,
        title: title,
        author: author,
        readPagesAmount: readPagesAmount,
        allPagesAmount: allPagesAmount,
      );

      verify(
        () => bookDataSource.updateBook(
          bookId: bookId,
          userId: userId,
          status: status,
          imageFile: imageFile,
          title: title,
          author: author,
          readPagesAmount: readPagesAmount,
          allPagesAmount: allPagesAmount,
        ),
      ).called(1);
    },
  );

  test(
    'delete book image, should call method from data source responsible for deleting book image',
    () async {
      const String bookId = 'b1';
      bookDataSource.mockDeleteBookImage();

      await repository.deleteBookImage(bookId: bookId, userId: userId);

      verify(
        () => bookDataSource.deleteBookImage(
          bookId: bookId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'delete book, should call method from data source responsible for deleting book',
    () async {
      const String bookId = 'b1';
      bookDataSource.mockDeleteBook();

      await repository.deleteBook(bookId: bookId, userId: userId);

      verify(
        () => bookDataSource.deleteBook(
          bookId: bookId,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'delete all user books, should load all user books and should delete each of them from data source',
    () async {
      final List<Book> userBooks = [
        createBook(id: 'b1', userId: userId),
        createBook(id: 'b2', userId: userId),
      ];
      bookDataSource.mockGetUserBooks(userBooks: userBooks);
      bookDataSource.mockDeleteBook();

      await repository.deleteAllUserBooks(userId: userId);

      verify(
        () => bookDataSource.getUserBooks(userId: userId),
      ).called(1);
      verify(
        () => bookDataSource.deleteBook(
          bookId: userBooks.first.id,
          userId: userId,
        ),
      ).called(1);
      verify(
        () => bookDataSource.deleteBook(
          bookId: userBooks.last.id,
          userId: userId,
        ),
      ).called(1);
    },
  );
}
