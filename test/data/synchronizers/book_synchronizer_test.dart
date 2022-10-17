import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:app/domain/entities/book.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/data/local_db/mock_book_local_db_service.dart';
import '../../mocks/data/remote_db/mock_book_remote_db_service.dart';

void main() {
  final bookLocalDbService = MockBookLocalDbService();
  final bookRemoteDbService = MockBookRemoteDbService();
  late BookSynchronizer synchronizer;
  const String userId = 'u1';

  setUp(() {
    synchronizer = BookSynchronizer(
      bookLocalDbService: bookLocalDbService,
      bookRemoteDbService: bookRemoteDbService,
    );
    bookLocalDbService.mockUpdateBookData(updatedBook: createBook());
  });

  tearDown(() {
    reset(bookLocalDbService);
    reset(bookRemoteDbService);
  });

  test(
    'synchronize unmodified user books, should add or delete books in local db',
    () async {
      final List<Book> localBooks = [
        createBook(id: 'b2'),
        createBook(id: 'b3', userId: userId),
      ];
      final List<Book> remoteBooks = [
        createBook(id: 'b1'),
        createBook(id: 'b2'),
      ];
      bookLocalDbService.mockLoadUserBooks(books: localBooks);
      bookRemoteDbService.mockLoadUserBooks(books: remoteBooks);
      bookLocalDbService.mockAddBook();
      bookLocalDbService.mockDeleteBook();

      await synchronizer.synchronizeUnmodifiedUserBooks(userId: userId);

      verify(
        () => bookLocalDbService.addBook(book: remoteBooks.first),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(
          bookId: localBooks.last.id,
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize unmodified user books, should update book in local db if there are two books with the same id in both databases',
    () async {
      final List<Book> localBooks = [
        createBook(id: 'b1', title: 'title'),
      ];
      final List<Book> remoteBooks = [
        createBook(id: 'b1', title: 'wow'),
      ];
      bookLocalDbService.mockLoadUserBooks(books: localBooks);
      bookRemoteDbService.mockLoadUserBooks(books: remoteBooks);
      bookLocalDbService.mockUpdateBookData(updatedBook: createBook());
      bookLocalDbService.mockUpdateBookImage(updatedBook: createBook());

      await synchronizer.synchronizeUnmodifiedUserBooks(userId: userId);

      verify(
        () => bookLocalDbService.updateBookData(
          bookId: remoteBooks.first.id,
          status: BookStatusMapper.mapFromEnumToString(
            remoteBooks.first.status,
          ),
          title: remoteBooks.first.title,
          author: remoteBooks.first.author,
          readPagesAmount: remoteBooks.first.readPagesAmount,
          allPagesAmount: remoteBooks.first.allPagesAmount,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookImage(
          bookId: remoteBooks.first.id,
          userId: remoteBooks.first.userId,
          imageData: remoteBooks.first.imageData,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user books marked as added, should load books marked as added from local db, should add them to remote db and should update their sync state to none',
    () async {
      final List<Book> booksMarkedAsAdded = [
        createBook(id: 'b1'),
        createBook(id: 'b2'),
      ];
      bookLocalDbService.mockLoadUserBooks(books: booksMarkedAsAdded);
      bookRemoteDbService.mockAddBook();

      await synchronizer.synchronizeUserBooksMarkedAsAdded(userId: userId);

      verify(
        () => bookRemoteDbService.addBook(book: booksMarkedAsAdded.first),
      ).called(1);
      verify(
        () => bookRemoteDbService.addBook(book: booksMarkedAsAdded.last),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: booksMarkedAsAdded.first.id,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: booksMarkedAsAdded.last.id,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user books marked as updated, should load books marked as updated from local db and should update them in remote db',
    () async {
      final List<Book> booksMarkedAsUpdated = [
        createBook(id: 'b1', userId: userId),
        createBook(id: 'b2', userId: userId),
      ];
      bookLocalDbService.mockLoadUserBooks(books: booksMarkedAsUpdated);
      bookRemoteDbService.mockUpdateBookData();
      bookRemoteDbService.mockUpdateBookImage();

      await synchronizer.synchronizeUserBooksMarkedAsUpdated(userId: userId);

      verify(
        () => bookRemoteDbService.updateBookData(
          bookId: booksMarkedAsUpdated.first.id,
          userId: booksMarkedAsUpdated.first.userId,
          status: BookStatusMapper.mapFromEnumToString(
            booksMarkedAsUpdated.first.status,
          ),
          title: booksMarkedAsUpdated.first.title,
          author: booksMarkedAsUpdated.first.author,
          readPagesAmount: booksMarkedAsUpdated.first.readPagesAmount,
          allPagesAmount: booksMarkedAsUpdated.first.allPagesAmount,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.updateBookData(
          bookId: booksMarkedAsUpdated.last.id,
          userId: booksMarkedAsUpdated.last.userId,
          status: BookStatusMapper.mapFromEnumToString(
            booksMarkedAsUpdated.first.status,
          ),
          title: booksMarkedAsUpdated.last.title,
          author: booksMarkedAsUpdated.last.author,
          readPagesAmount: booksMarkedAsUpdated.last.readPagesAmount,
          allPagesAmount: booksMarkedAsUpdated.last.allPagesAmount,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.updateBookImage(
          bookId: booksMarkedAsUpdated.first.id,
          userId: userId,
          imageData: booksMarkedAsUpdated.first.imageData,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.updateBookImage(
          bookId: booksMarkedAsUpdated.last.id,
          userId: userId,
          imageData: booksMarkedAsUpdated.last.imageData,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: booksMarkedAsUpdated.first.id,
          syncState: SyncState.none,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.updateBookData(
          bookId: booksMarkedAsUpdated.last.id,
          syncState: SyncState.none,
        ),
      ).called(1);
    },
  );

  test(
    'synchronize user books marked as deleted, should load books marked as deleted from local db and should delete them from both databases',
    () async {
      final List<Book> booksMarkedAsDeleted = [
        createBook(id: 'b1'),
        createBook(id: 'b3'),
      ];
      bookLocalDbService.mockLoadUserBooks(books: booksMarkedAsDeleted);
      bookRemoteDbService.mockDeleteBook();
      bookLocalDbService.mockDeleteBook();

      await synchronizer.synchronizeUserBooksMarkedAsDeleted(userId: userId);

      verify(
        () => bookRemoteDbService.deleteBook(
          userId: userId,
          bookId: booksMarkedAsDeleted.first.id,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(
          userId: userId,
          bookId: booksMarkedAsDeleted.first.id,
        ),
      ).called(1);
      verify(
        () => bookRemoteDbService.deleteBook(
          userId: userId,
          bookId: booksMarkedAsDeleted.last.id,
        ),
      ).called(1);
      verify(
        () => bookLocalDbService.deleteBook(
          userId: userId,
          bookId: booksMarkedAsDeleted.last.id,
        ),
      ).called(1);
    },
  );
}
