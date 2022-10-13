import 'package:app/domain/entities/book.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/use_cases/book/mock_get_all_user_books_use_case.dart';
import '../../mocks/use_cases/book/mock_load_all_user_books_use_case.dart';

void main() {
  final loadAllUserBooksUseCase = MockLoadAllUserBooksUseCase();
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getAllUserBooksUseCase = MockGetAllUserBooksUseCase();
  final List<Book> userBooks = [
    createBook(id: 'b1'),
    createBook(id: 'b2'),
  ];

  LibraryBloc createBloc() {
    return LibraryBloc(
      loadAllUserBooksUseCase: loadAllUserBooksUseCase,
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getAllUserBooksUseCase: getAllUserBooksUseCase,
    );
  }

  LibraryState createState({
    BlocStatus status = const BlocStatusComplete(),
    List<Book>? books,
  }) {
    return LibraryState(
      status: status,
      books: books,
    );
  }

  tearDown(() {
    reset(loadAllUserBooksUseCase);
    reset(getLoggedUserIdUseCase);
    reset(getAllUserBooksUseCase);
  });

  blocTest(
    'initialize, should emit appropriate status if logged user id is null',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock();
    },
    act: (LibraryBloc bloc) {
      bloc.add(
        const LibraryEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoggedUserNotFound(),
      ),
    ],
  );

  blocTest(
    'initialize, should emit loading status if logged user books are not loaded and should call use case responsible for loading all logged user books after 300ms delay',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      loadAllUserBooksUseCase.mock();
      getAllUserBooksUseCase.mock();
    },
    act: (LibraryBloc bloc) {
      bloc.add(
        const LibraryEventInitialize(),
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
        () => loadAllUserBooksUseCase.execute(userId: 'u1'),
      ).called(1);
    },
  );

  blocTest(
    'initialize, should emit logged user books and should call use case responsible for loading all logged user books after 300ms delay',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      loadAllUserBooksUseCase.mock();
      getAllUserBooksUseCase.mock(userBooks: []);
    },
    act: (LibraryBloc bloc) {
      bloc.add(
        const LibraryEventInitialize(),
      );
    },
    expect: () => [
      createState(
        books: [],
      ),
    ],
    verify: (_) async {
      await Future.delayed(
        const Duration(milliseconds: 300),
      );
      verify(
        () => loadAllUserBooksUseCase.execute(userId: 'u1'),
      ).called(1);
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
}
