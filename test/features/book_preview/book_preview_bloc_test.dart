import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookByIdUseCase extends Mock implements GetBookByIdUseCase {}

void main() {
  final getBookByIdUseCase = MockGetBookByIdUseCase();

  BookPreviewBloc createBloc() {
    return BookPreviewBloc(
      getBookByIdUseCase: getBookByIdUseCase,
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
}
