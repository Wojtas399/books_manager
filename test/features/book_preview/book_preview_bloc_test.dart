import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookByIdUseCase extends Mock implements GetBookByIdUseCase {}

class MockDeleteBookUseCase extends Mock implements DeleteBookUseCase {}

void main() {
  final getBookByIdUseCase = MockGetBookByIdUseCase();
  final deleteBookUseCase = MockDeleteBookUseCase();

  BookPreviewBloc createBloc({
    Book? book,
  }) {
    return BookPreviewBloc(
      getBookByIdUseCase: getBookByIdUseCase,
      deleteBookUseCase: deleteBookUseCase,
      book: book,
    );
  }

  BookPreviewState createState({
    BlocStatus status = const BlocStatusInProgress(),
    Book? book,
  }) {
    return BookPreviewState(
      status: status,
      book: book,
    );
  }

  tearDown(() {
    reset(getBookByIdUseCase);
    reset(deleteBookUseCase);
  });

  group(
    'initialize',
    () {
      const String bookId = 'b1';
      final Book book = createBook(id: bookId);

      blocTest(
        'should set book listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getBookByIdUseCase.execute(bookId: bookId),
          ).thenAnswer((_) => Stream.value(book));
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

  group(
    'book updated',
    () {
      final Book book = createBook(id: 'b1');

      blocTest(
        'should update book in state',
        build: () => createBloc(),
        act: (BookPreviewBloc bloc) {
          bloc.add(
            BookPreviewEventBookUpdated(book: book),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            book: book,
          ),
        ],
      );
    },
  );

  blocTest(
    'delete book, should not call use case responsible for deleting book if bookId is null',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteBookUseCase.execute(bookId: any(named: 'bookId')),
      ).thenAnswer((_) async => '');
    },
    act: (BookPreviewBloc bloc) {
      bloc.add(
        const BookPreviewEventDeleteBook(),
      );
    },
    expect: () => [],
    verify: (_) {
      verifyNever(
        () => deleteBookUseCase.execute(bookId: any(named: 'bookId')),
      );
    },
  );

  blocTest(
    'delete book, should call use case responsible for deleting book if bookId is not null',
    build: () => createBloc(book: createBook(id: 'b1')),
    setUp: () {
      when(
        () => deleteBookUseCase.execute(bookId: 'b1'),
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
        book: createBook(id: 'b1'),
      ),
      createState(
        status: const BlocStatusComplete<BookPreviewBlocInfo>(
          info: BookPreviewBlocInfo.bookHasBeenDeleted,
        ),
        book: createBook(id: 'b1'),
      ),
    ],
    verify: (_) {
      verify(
        () => deleteBookUseCase.execute(bookId: 'b1'),
      ).called(1);
    },
  );
}
