import 'package:app/domain/entities/book.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_get_all_user_books_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getAllUserBooksUseCase = MockGetAllUserBooksUseCase();
  final List<Book> userBooks = [
    createBook(id: 'b1'),
    createBook(id: 'b2'),
  ];

  LibraryBloc createBloc() {
    return LibraryBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getAllUserBooksUseCase: getAllUserBooksUseCase,
    );
  }

  LibraryState createState({
    BlocStatus status = const BlocStatusComplete(),
    String searchValue = '',
    List<Book>? books,
  }) {
    return LibraryState(
      status: status,
      searchValue: searchValue,
      books: books,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(getAllUserBooksUseCase);
  });

  group(
    'initialize',
    () {
      void eventCall(LibraryBloc bloc) {
        bloc.add(
          const LibraryEventInitialize(),
        );
      }

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
        act: (LibraryBloc bloc) => eventCall(bloc),
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
        'logged user exist, should set user books listener',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
          getAllUserBooksUseCase.mock(userBooks: userBooks);
        },
        act: (LibraryBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            books: userBooks,
          ),
        ],
        verify: (_) {
          verify(
            () => getAllUserBooksUseCase.execute(userId: 'u1'),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'books updated, should update books in state',
    build: () => createBloc(),
    act: (LibraryBloc bloc) {
      bloc.add(
        LibraryEventBooksUpdated(books: userBooks),
      );
    },
    expect: () => [
      createState(
        books: userBooks,
      ),
    ],
  );

  blocTest(
    'search value changed, should update search value in state',
    build: () => createBloc(),
    act: (LibraryBloc bloc) {
      bloc.add(
        const LibraryEventSearchValueChanged(searchValue: 'search'),
      );
    },
    expect: () => [
      createState(
        searchValue: 'search',
      ),
    ],
  );
}
