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
import '../../mocks/domain/use_cases/book/mock_get_book_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_start_reading_book_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_update_current_page_number_after_reading_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getBookUseCase = MockGetBookUseCase();
  final startReadingBookUseCase = MockStartReadingBookUseCase();
  final updateCurrentPageNumberAfterReadingUseCase =
      MockUpdateCurrentPageNumberAfterReadingUseCase();
  final deleteBookUseCase = MockDeleteBookUseCase();
  const String bookId = 'b1';
  const String userId = 'u1';

  BookPreviewBloc createBloc({
    Book? book,
  }) {
    return BookPreviewBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getBookUseCase: getBookUseCase,
      startReadingBookUseCase: startReadingBookUseCase,
      updateCurrentPageNumberAfterReadingUseCase:
          updateCurrentPageNumberAfterReadingUseCase,
      deleteBookUseCase: deleteBookUseCase,
      bookId: bookId,
      book: book,
    );
  }

  BookPreviewState createState({
    BlocStatus status = const BlocStatusInitial(),
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
    reset(getBookUseCase);
    reset(startReadingBookUseCase);
    reset(updateCurrentPageNumberAfterReadingUseCase);
    reset(deleteBookUseCase);
  });

  group(
    'initialize',
    () {
      final Book book = createBook(id: bookId, userId: userId);

      void eventCall(BookPreviewBloc bloc) => bloc.add(
            const BookPreviewEventInitialize(bookId: bookId),
          );

      setUp(() {
        getBookUseCase.mock(book: book);
      });

      tearDown(() {
        verify(
          () => getLoggedUserIdUseCase.execute(),
        ).called(1);
      });

      blocTest(
        'logged user does not exist, should emit book as null',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            book: null,
          ),
        ],
      );

      blocTest(
        'logged user exists, should set book listener',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: userId);
        },
        act: (BookPreviewBloc bloc) => eventCall(bloc),
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
            () => getBookUseCase.execute(bookId: bookId, userId: userId),
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
        BookPreviewEventBookUpdated(
          book: createBook(id: 'b1'),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        book: createBook(id: 'b1'),
      ),
    ],
  );

  group(
    'start reading',
    () {
      const bool fromBeginning = true;
      final Book book = createBook(id: bookId, userId: userId);

      void eventCall(BookPreviewBloc bloc) {
        bloc.add(
          const BookPreviewEventStartReading(fromBeginning: fromBeginning),
        );
      }

      setUp(() {
        startReadingBookUseCase.mock();
      });

      blocTest(
        'book is not loaded, should do nothing',
        build: () => createBloc(),
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => startReadingBookUseCase.execute(
              bookId: any(named: 'bookId'),
              userId: any(named: 'userId'),
              fromBeginning: fromBeginning,
            ),
          );
        },
      );

      blocTest(
        'book is loaded, should call use case responsible for starting reading book',
        build: () => createBloc(book: book),
        act: (BookPreviewBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: book,
          ),
          createState(
            status: const BlocStatusComplete(),
            book: book,
          ),
        ],
        verify: (_) {
          verify(
            () => startReadingBookUseCase.execute(
              bookId: bookId,
              userId: userId,
              fromBeginning: true,
            ),
          ).called(1);
        },
      );
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
