import 'dart:typed_data';

import 'package:app/domain/entities/book.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late BookPreviewState state;

  setUp(() {
    state = BookPreviewState(
      status: const BlocStatusInitial(),
      bookId: 'b1',
      initialBookImageData: null,
      book: null,
    );
  });

  test(
    'book image data, should return book image data',
    () {
      final Uint8List expectedImageData = Uint8List(10);
      final Book book = createBook(imageData: expectedImageData);
      state = state.copyWith(book: book);

      final Uint8List? imageData = state.bookImageData;

      expect(imageData, expectedImageData);
    },
  );

  test(
    'book status, should return book status',
    () {
      const BookStatus expectedBookStatus = BookStatus.inProgress;
      final Book book = createBook(status: expectedBookStatus);
      state = state.copyWith(book: book);

      final BookStatus? bookStatus = state.bookStatus;

      expect(bookStatus, expectedBookStatus);
    },
  );

  test(
    'title, should return book title',
    () {
      const String expectedTitle = 'title';
      final Book book = createBook(title: expectedTitle);
      state = state.copyWith(book: book);

      final String? title = state.title;

      expect(title, expectedTitle);
    },
  );

  test(
    'author, should return book author',
    () {
      const String expectedAuthor = 'author';
      final Book book = createBook(author: expectedAuthor);
      state = state.copyWith(book: book);

      final String? author = state.author;

      expect(author, expectedAuthor);
    },
  );

  test(
    'read pages amount, should return amount of read pages of book',
    () {
      const int expectedAmount = 20;
      final Book book = createBook(readPagesAmount: expectedAmount);
      state = state.copyWith(book: book);

      final int? readPagesAmount = state.readPagesAmount;

      expect(readPagesAmount, expectedAmount);
    },
  );

  test(
    'all pages amount, should return amount of all pages of book',
    () {
      const int expectedAmount = 200;
      final Book book = createBook(allPagesAmount: expectedAmount);
      state = state.copyWith(book: book);

      final int? allPagesAmount = state.allPagesAmount;

      expect(allPagesAmount, expectedAmount);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with book',
    () {
      final Book expectedBook = createBook(title: 'title');

      state = state.copyWith(book: expectedBook);
      final state2 = state.copyWith();

      expect(state.title, 'title');
      expect(state2.title, 'title');
    },
  );

  test(
    'copy with info',
    () {
      const BookPreviewBlocInfo expectedInfo =
          BookPreviewBlocInfo.bookHasBeenDeleted;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<BookPreviewBlocInfo>(
          info: expectedInfo,
        ),
      );
    },
  );

  test(
    'copy with error',
    () {
      const BookPreviewBlocError expectedError =
          BookPreviewBlocError.newCurrentPageNumberIsTooHigh;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<BookPreviewBlocError>(
          error: expectedError,
        ),
      );
    },
  );
}
