import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_user_books_in_progress_use_case.dart';
import 'package:app/domain/use_cases/book/load_user_books_in_progress_use_case.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLoggedUserIdUseCase extends Mock
    implements GetLoggedUserIdUseCase {}

class MockLoadUserBooksInProgressUseCase extends Mock
    implements LoadUserBooksInProgressUseCase {}

class MockGetUserBooksInProgressUseCase extends Mock
    implements GetUserBooksInProgressUseCase {}

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

  group(
    'initialize',
    () {
      const String userId = 'u1';
      final List<Book> booksInProgress = [
        createBook(id: 'b1'),
        createBook(id: 'b2'),
      ];

      blocTest(
        'logged user id is null, should not do anything',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getLoggedUserIdUseCase.execute(),
          ).thenAnswer((_) => Stream.value(null));
        },
        act: (ReadingBloc bloc) {
          bloc.add(
            const ReadingEventInitialize(),
          );
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => loadUserBooksInProgressUseCase.execute(
              userId: any(named: 'userId'),
            ),
          );
          verifyNever(
            () => getUserBooksInProgressUseCase.execute(
              userId: any(named: 'userId'),
            ),
          );
        },
      );

      blocTest(
        'logged user id is not null, should call use case responsible for loading user books in progress and should set listener for these books',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getLoggedUserIdUseCase.execute(),
          ).thenAnswer((_) => Stream.value(userId));
          when(
            () => loadUserBooksInProgressUseCase.execute(userId: userId),
          ).thenAnswer((_) async => '');
          when(
            () => getUserBooksInProgressUseCase.execute(userId: userId),
          ).thenAnswer((_) => Stream.value(booksInProgress));
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
          createState(
            status: const BlocStatusComplete(),
            booksInProgress: booksInProgress,
          ),
        ],
        verify: (_) {
          verify(
            () => loadUserBooksInProgressUseCase.execute(userId: userId),
          ).called(1);
          verify(
            () => getUserBooksInProgressUseCase.execute(userId: userId),
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
