import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/use_cases/book/mock_delete_book_use_case.dart';
import '../../mocks/use_cases/book/mock_get_book_by_id_use_case.dart';
import '../../mocks/use_cases/book/mock_start_reading_book_use_case.dart';
import '../../mocks/use_cases/book/mock_update_current_page_number_after_reading_use_case.dart';

void main() {
  final getBookByIdUseCase = MockGetBookByIdUseCase();
  final startReadingBookUseCase = MockStartReadingBookUseCase();
  final updateCurrentPageNumberAfterReadingUseCase =
      MockUpdateCurrentPageNumberAfterReadingUseCase();
  final deleteBookUseCase = MockDeleteBookUseCase();
  const String bookId = 'b1';

  BookPreviewBloc createBloc({
    Book? book,
  }) {
    return BookPreviewBloc(
      getBookByIdUseCase: getBookByIdUseCase,
      startReadingBookUseCase: startReadingBookUseCase,
      updateCurrentPageNumberAfterReadingUseCase:
          updateCurrentPageNumberAfterReadingUseCase,
      deleteBookUseCase: deleteBookUseCase,
      bookId: bookId,
      book: book,
    );
  }

  BookPreviewState createState({
    BlocStatus status = const BlocStatusInProgress(),
    Book? book,
  }) {
    return BookPreviewState(
      status: status,
      bookId: bookId,
      initialBookImageData: null,
      book: book,
    );
  }

  tearDown(() {
    reset(getBookByIdUseCase);
    reset(startReadingBookUseCase);
    reset(updateCurrentPageNumberAfterReadingUseCase);
    reset(deleteBookUseCase);
  });

  group(
    'initialize',
    () {
      final Book book = createBook(id: bookId);

      blocTest(
        'should set book listener',
        build: () => createBloc(),
        setUp: () {
          getBookByIdUseCase.mock(book: book);
        },
        act: (BookPreviewBloc bloc) {
          bloc.add(
            const BookPreviewEventInitialize(bookId: bookId),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            book: book,
          ),
        ],
        verify: (_) {
          verify(
            () => getBookByIdUseCase.execute(bookId: bookId),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'book updated, should update book in state',
    build: () => createBloc(),
    act: (BookPreviewBloc bloc) {
      bloc.add(
        BookPreviewEventBookUpdated(book: createBook(id: 'b1')),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        book: createBook(id: 'b1'),
      ),
    ],
  );

  blocTest(
    'start reading, should call use case responsible for starting reading book',
    build: () => createBloc(
      book: createBook(id: bookId),
    ),
    setUp: () {
      startReadingBookUseCase.mock();
    },
    act: (BookPreviewBloc bloc) {
      bloc.add(
        const BookPreviewEventStartReading(fromBeginning: true),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        book: createBook(id: bookId),
      ),
      createState(
        status: const BlocStatusComplete(),
        book: createBook(id: bookId),
      ),
    ],
    verify: (_) {
      verify(
        () => startReadingBookUseCase.execute(
          bookId: bookId,
          fromBeginning: true,
        ),
      ).called(1);
    },
  );

  group(
    'update current page number',
    () {
      const String bookId = 'b1';
      const int newCurrentPageNumber = 50;

      void callUpdateCurrentPageNumberAfterReadingUseCase() =>
          updateCurrentPageNumberAfterReadingUseCase.execute(
            bookId: bookId,
            newCurrentPageNumber: newCurrentPageNumber,
          );

      blocTest(
        'should try to call use case responsible for updating current page number',
        build: () => createBloc(book: createBook(id: bookId)),
        setUp: () {
          updateCurrentPageNumberAfterReadingUseCase.mock();
        },
        act: (BookPreviewBloc bloc) {
          bloc.add(
            const BookPreviewEventUpdateCurrentPageNumber(
              currentPageNumber: newCurrentPageNumber,
            ),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: createBook(id: bookId),
          ),
          createState(
            status: const BlocStatusComplete<BookPreviewBlocInfo>(
              info: BookPreviewBlocInfo.currentPageNumberHasBeenUpdated,
            ),
            book: createBook(id: bookId),
          ),
        ],
        verify: (_) {
          verify(
            callUpdateCurrentPageNumberAfterReadingUseCase,
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate error if called use case throws book error',
        build: () => createBloc(book: createBook(id: bookId)),
        setUp: () {
          updateCurrentPageNumberAfterReadingUseCase.mock(
            throwable: const BookError(
              code: BookErrorCode.newCurrentPageIsTooHigh,
            ),
          );
        },
        act: (BookPreviewBloc bloc) {
          bloc.add(
            const BookPreviewEventUpdateCurrentPageNumber(
              currentPageNumber: newCurrentPageNumber,
            ),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: createBook(id: bookId),
          ),
          createState(
            status: const BlocStatusError<BookPreviewBlocError>(
              error: BookPreviewBlocError.newCurrentPageNumberIsTooHigh,
            ),
            book: createBook(id: bookId),
          ),
        ],
        verify: (_) {
          verify(
            callUpdateCurrentPageNumberAfterReadingUseCase,
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'delete book, should call use case responsible for deleting book',
    build: () => createBloc(
      book: createBook(id: bookId),
    ),
    setUp: () {
      when(
        () => deleteBookUseCase.execute(bookId: bookId),
      ).thenAnswer((_) async => '');
    },
    act: (BookPreviewBloc bloc) {
      bloc.add(
        const BookPreviewEventDeleteBook(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
        book: createBook(id: bookId),
      ),
      createState(
        status: const BlocStatusComplete<BookPreviewBlocInfo>(
          info: BookPreviewBlocInfo.bookHasBeenDeleted,
        ),
        book: createBook(id: bookId),
      ),
    ],
    verify: (_) {
      verify(
        () => deleteBookUseCase.execute(bookId: bookId),
      ).called(1);
    },
  );
}
