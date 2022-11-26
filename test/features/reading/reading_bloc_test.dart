import 'package:app/domain/entities/book.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_get_books_in_progress_of_user_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getBooksInProgressOfUserUseCase = MockGetBooksInProgressOfUserUseCase();

  ReadingBloc createBloc() {
    return ReadingBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getBooksInProgressOfUserUseCase: getBooksInProgressOfUserUseCase,
    );
  }

  ReadingState createState({
    BlocStatus status = const BlocStatusInitial(),
    List<Book>? booksInProgress,
  }) {
    return ReadingState(
      status: status,
      booksInProgress: booksInProgress,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(getBooksInProgressOfUserUseCase);
  });

  group(
    'initialize',
    () {
      void eventCall(ReadingBloc bloc) => bloc.add(
            const ReadingEventInitialize(),
          );

      tearDown(() {
        verify(
          () => getLoggedUserIdUseCase.execute(),
        ).called(1);
      });

      blocTest(
        'logged user does not exist, should emit books as null',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
        },
        act: (ReadingBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            booksInProgress: null,
          ),
        ],
      );

      blocTest(
        'logged user exists, should set listener for user books in progress',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
          getBooksInProgressOfUserUseCase.mock(booksInProgressOfUser: []);
        },
        act: (ReadingBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            booksInProgress: [],
          ),
        ],
        verify: (_) {
          verify(
            () => getBooksInProgressOfUserUseCase.execute(userId: 'u1'),
          ).called(1);
        },
      );
    },
  );

  group(
    'books in progress updated',
    () {
      final List<Book> booksInProgress = [
        createBook(id: 'b1'),
        createBook(id: 'b2'),
      ];

      blocTest(
        'should update books in progress in state',
        build: () => createBloc(),
        act: (ReadingBloc bloc) {
          bloc.add(
            ReadingEventBooksInProgressUpdated(
              booksInProgress: booksInProgress,
            ),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            booksInProgress: booksInProgress,
          ),
        ],
      );
    },
  );
}
