import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/get_books_by_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/load_all_user_books_use_case.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadAllUserBooksUseCase extends Mock
    implements LoadAllUserBooksUseCase {}

class MockGetLoggedUserIdUseCase extends Mock
    implements GetLoggedUserIdUseCase {}

class MockGetBooksByUserIdUseCase extends Mock
    implements GetBooksByUserIdUseCase {}

void main() {
  final loadAllUserBooksUseCase = MockLoadAllUserBooksUseCase();
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getBooksByUserIdUseCase = MockGetBooksByUserIdUseCase();
  final List<Book> userBooks = [
    createBook(id: 'b1'),
    createBook(id: 'b2'),
  ];

  LibraryBloc createBloc() {
    return LibraryBloc(
      loadAllUserBooksUseCase: loadAllUserBooksUseCase,
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getBooksByUserIdUseCase: getBooksByUserIdUseCase,
    );
  }

  LibraryState createState({
    BlocStatus status = const BlocStatusComplete(),
    List<Book> books = const [],
  }) {
    return LibraryState(
      status: status,
      books: books,
    );
  }

  tearDown(() {
    reset(loadAllUserBooksUseCase);
    reset(getLoggedUserIdUseCase);
    reset(getBooksByUserIdUseCase);
  });

  blocTest(
    'initialize, should emit appropriate status if logged user id is null',
    build: () => createBloc(),
    setUp: () {
      when(
        () => getLoggedUserIdUseCase.execute(),
      ).thenAnswer((_) => Stream.value(null));
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
      createState(
        status: const BlocStatusLoggedUserNotFound(),
      ),
    ],
  );

  blocTest(
    'initialize, should call use case responsible for loading all user books and should set user books listener',
    build: () => createBloc(),
    setUp: () {
      when(
        () => getLoggedUserIdUseCase.execute(),
      ).thenAnswer((_) => Stream.value('u1'));
      when(
        () => loadAllUserBooksUseCase.execute(userId: 'u1'),
      ).thenAnswer((_) async => '');
      when(
        () => getBooksByUserIdUseCase.execute(userId: 'u1'),
      ).thenAnswer((_) => Stream.value(userBooks));
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
      createState(
        books: userBooks,
      ),
    ],
    verify: (_) {
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
