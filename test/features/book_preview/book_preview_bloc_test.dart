import 'package:app/config/errors.dart';
import 'package:app/domain/entities/book.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_delete_book_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_get_book_by_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_start_reading_book_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_update_current_page_number_after_reading_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
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
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
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
    reset(getLoggedUserIdUseCase);
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
      const String loggedUserId = 'u1';
      final Book book = createBook(id: bookId);
      const int newCurrentPageNumber = 50;

      void eventCall(BookPreviewBloc bloc) => bloc.add(
            const BookPreviewEventUpdateCurrentPageNumber(
              currentPageNumber: newCurrentPageNumber,
            ),
          );

      void useCaseCall() => updateCurrentPageNumberAfterReadingUseCase.execute(
            userId: loggedUserId,
            bookId: bookId,
            newCurrentPageNumber: newCurrentPageNumber,
          );

      blocTest(
        'logged user does not exist, should emit logged user not found status',
        build: () => createBloc(book: book),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: book,
          ),
          createState(
            status: const BlocStatusLoggedUserNotFound(),
            book: book,
          ),
        ],
        verify: (_) {
          verifyNever(
            () => updateCurrentPageNumberAfterReadingUseCase.execute(
              userId: any(named: 'userId'),
              bookId: bookId,
              newCurrentPageNumber: newCurrentPageNumber,
            ),
          );
        },
      );

      blocTest(
        'logged user exists, should try to call use case responsible for updating current page number',
        build: () => createBloc(book: book),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          updateCurrentPageNumberAfterReadingUseCase.mock();
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: book,
          ),
          createState(
            status: const BlocStatusComplete<BookPreviewBlocInfo>(
              info: BookPreviewBlocInfo.currentPageNumberHasBeenUpdated,
            ),
            book: book,
          ),
        ],
        verify: (_) {
          verify(useCaseCall).called(1);
        },
      );

      blocTest(
        'should emit appropriate error if called use case throws book error because new current page is too high',
        build: () => createBloc(book: book),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          updateCurrentPageNumberAfterReadingUseCase.mock(
            throwable: const BookError(
              code: BookErrorCode.newCurrentPageIsTooHigh,
            ),
          );
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: book,
          ),
          createState(
            status: const BlocStatusError<BookPreviewBlocError>(
              error: BookPreviewBlocError.newCurrentPageNumberIsTooHigh,
            ),
            book: book,
          ),
        ],
        verify: (_) {
          verify(useCaseCall).called(1);
        },
      );

      blocTest(
        'should emit appropriate error if called use case throws book error because new current page is lower than read pages amount from the book',
        build: () => createBloc(book: createBook(id: bookId)),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          updateCurrentPageNumberAfterReadingUseCase.mock(
            throwable: const BookError(
              code: BookErrorCode.newCurrentPageIsLowerThanReadPagesAmount,
            ),
          );
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: book,
          ),
          createState(
            status: const BlocStatusError<BookPreviewBlocError>(
              error:
                  BookPreviewBlocError.newCurrentPageIsLowerThanReadPagesAmount,
            ),
            book: book,
          ),
        ],
        verify: (_) {
          verify(useCaseCall).called(1);
        },
      );
    },
  );

  group(
    'delete book',
    () {
      final Book book = createBook(id: bookId);

      void eventCall(BookPreviewBloc bloc) => bloc.add(
            const BookPreviewEventDeleteBook(),
          );

      setUp(() {
        deleteBookUseCase.mock();
      });

      blocTest(
        'logged user does not exist, should emit logged user not found status',
        build: () => createBloc(book: book),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: book,
          ),
          createState(
            status: const BlocStatusLoggedUserNotFound(),
            book: book,
          ),
        ],
        verify: (_) {
          verifyNever(
            () => deleteBookUseCase.execute(
              bookId: bookId,
              userId: any(named: 'userId'),
            ),
          );
        },
      );

      blocTest(
        'logged user exists, should call use case responsible for deleting book',
        build: () => createBloc(book: book),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: book,
          ),
          createState(
            status: const BlocStatusComplete<BookPreviewBlocInfo>(
              info: BookPreviewBlocInfo.bookHasBeenDeleted,
            ),
            book: book,
          ),
        ],
        verify: (_) {
          verify(
            () => deleteBookUseCase.execute(bookId: bookId, userId: 'u1'),
          ).called(1);
        },
      );
    },
  );
}
