import 'package:app/domain/entities/book.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/use_cases/book/mock_get_user_books_in_progress_use_case.dart';
import '../../mocks/use_cases/book/mock_load_user_books_in_progress_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final loadUserBooksInProgressUseCase = MockLoadUserBooksInProgressUseCase();
  final getUserBooksInProgressUseCase = MockGetUserBooksInProgressUseCase();

  ReadingBloc createBloc() {
    return ReadingBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      loadUserBooksInProgressUseCase: loadUserBooksInProgressUseCase,
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
    reset(loadUserBooksInProgressUseCase);
    reset(getUserBooksInProgressUseCase);
  });

  blocTest(
    'initialize, should emit appropriate status if logged user id is null',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock();
    },
    act: (ReadingBloc bloc) {
      bloc.add(
        const ReadingEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoggedUserNotFound(),
      ),
    ],
  );

  blocTest(
    'initialize should emit loading status if logged user books are not loaded and should call use case responsible for loading logged user books in progress after 300ms delay',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      loadUserBooksInProgressUseCase.mock();
      getUserBooksInProgressUseCase.mock();
    },
    act: (ReadingBloc bloc) {
      bloc.add(
        const ReadingEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
    ],
    verify: (_) async {
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      verify(
        () => loadUserBooksInProgressUseCase.execute(userId: 'u1'),
      ).called(1);
    },
  );

  blocTest(
    'initialize, should emit logged user books in progress and should call use case responsible for loading logged user books in progress after 300ms delay',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      loadUserBooksInProgressUseCase.mock();
      getUserBooksInProgressUseCase.mock(userBooksInProgress: []);
    },
    act: (ReadingBloc bloc) {
      bloc.add(
        const ReadingEventInitialize(),
      );
    },
    expect: () => [
      createState(
        booksInProgress: [],
      ),
    ],
    verify: (_) async {
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      verify(
        () => loadUserBooksInProgressUseCase.execute(userId: 'u1'),
      ).called(1);
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
