import 'package:app/domain/entities/book.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_get_user_books_in_progress_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getUserBooksInProgressUseCase = MockGetUserBooksInProgressUseCase();

  ReadingBloc createBloc() {
    return ReadingBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getUserBooksInProgressUseCase: getUserBooksInProgressUseCase,
    );
  }

  ReadingState createState({
    BlocStatus status = const BlocStatusComplete(),
    List<Book> booksInProgress = const [],
  }) {
    return ReadingState(
      status: status,
      booksInProgress: booksInProgress,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(getUserBooksInProgressUseCase);
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
        'logged user does not exist, should emit logged user not found status',
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
            status: const BlocStatusLoggedUserNotFound(),
          ),
        ],
      );

      blocTest(
        'logged user exists, should set listener for user books in progress',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
          getUserBooksInProgressUseCase.mock(userBooksInProgress: []);
        },
        act: (ReadingBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            booksInProgress: [],
          ),
        ],
        verify: (_) {
          verify(
            () => getUserBooksInProgressUseCase.execute(userId: 'u1'),
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
            booksInProgress: booksInProgress,
          ),
        ],
      );
    },
  );
}
