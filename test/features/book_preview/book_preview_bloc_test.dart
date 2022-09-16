import 'package:app/domain/entities/book.dart';
import 'package:app/domain/use_cases/book/delete_book_use_case.dart';
import 'package:app/domain/use_cases/book/get_book_by_id_use_case.dart';
import 'package:app/domain/use_cases/book/start_reading_book_use_case.dart';
import 'package:app/features/book_preview/bloc/book_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookByIdUseCase extends Mock implements GetBookByIdUseCase {}

class MockStartReadingBookUseCase extends Mock
    implements StartReadingBookUseCase {}

class MockDeleteBookUseCase extends Mock implements DeleteBookUseCase {}

void main() {
  final getBookByIdUseCase = MockGetBookByIdUseCase();
  final startReadingBookUseCase = MockStartReadingBookUseCase();
  final deleteBookUseCase = MockDeleteBookUseCase();

  BookPreviewBloc createBloc({
    Book? book,
  }) {
    return BookPreviewBloc(
      getBookByIdUseCase: getBookByIdUseCase,
      startReadingBookUseCase: startReadingBookUseCase,
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

  blocTest(
    'book updated, should update book in state',
    build: () => createBloc(),
    act: (BookPreviewBloc bloc) {
      bloc.add(
        BookPreviewEventBookUpdated(book: createBook(id: 'b1')),
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
      const String bookId = 'b1';

      setUp(() {
        when(
          () => startReadingBookUseCase.execute(
            bookId: bookId,
            fromBeginning: any(named: 'fromBeginning'),
          ),
        ).thenAnswer((_) async => '');
      });

      blocTest(
        'book is null, should not call use case responsible for starting reading book',
        build: () => createBloc(),
        act: (BookPreviewBloc bloc) {
          bloc.add(
            const BookPreviewEventStartReading(),
          );
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => startReadingBookUseCase.execute(
              bookId: any(named: 'bookId'),
              fromBeginning: any(named: 'fromBeginning'),
            ),
          );
        },
      );

      blocTest(
        'book is not null, should call use case responsible for starting reading book',
        build: () => createBloc(
          book: createBook(id: bookId),
        ),
        act: (BookPreviewBloc bloc) {
          bloc.add(
            const BookPreviewEventStartReading(fromBeginning: true),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: createBook(id: bookId),
          ),
          createState(
            status: const BlocStatusComplete(),
            book: createBook(id: bookId),
          ),
        ],
        verify: (_) {
          verify(
            () => startReadingBookUseCase.execute(
              bookId: bookId,
              fromBeginning: true,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'delete book',
    () {
      const String bookId = 'b1';

      setUp(() {
        when(
          () => deleteBookUseCase.execute(
            bookId: any(named: 'bookId'),
          ),
        ).thenAnswer((_) async => '');
      });

      blocTest(
        'book is null, should not call use case responsible for deleting book',
        build: () => createBloc(),
        act: (BookPreviewBloc bloc) {
          bloc.add(
            const BookPreviewEventDeleteBook(),
          );
        },
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => deleteBookUseCase.execute(
              bookId: any(named: 'bookId'),
            ),
          );
        },
      );

      blocTest(
        'book is not null, should call use case responsible for deleting book',
        build: () => createBloc(
          book: createBook(id: bookId),
        ),
        act: (BookPreviewBloc bloc) {
          bloc.add(
            const BookPreviewEventDeleteBook(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            book: createBook(id: bookId),
          ),
          createState(
            status: const BlocStatusComplete<BookPreviewBlocInfo>(
              info: BookPreviewBlocInfo.bookHasBeenDeleted,
            ),
            book: createBook(id: bookId),
          ),
        ],
        verify: (_) {
          verify(
            () => deleteBookUseCase.execute(bookId: bookId),
          ).called(1);
        },
      );
    },
  );
}
