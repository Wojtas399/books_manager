import 'package:app/domain/entities/book.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LibraryState state;

  setUp(() {
    state = const LibraryState(
      status: BlocStatusInitial(),
      books: [],
    );
  });

  test(
    'sorted books, should return books sorted by title',
    () {
      final List<Book> unsortedBooks = [
        createBook(title: 'boom'),
        createBook(title: 'wow'),
        createBook(title: 'abc'),
      ];
      final List<Book> sortedBooks = [
        unsortedBooks[2],
        unsortedBooks[0],
        unsortedBooks[1],
      ];
      state = state.copyWith(books: unsortedBooks);

      final List<Book>? books = state.sortedBooks;

      expect(books, sortedBooks);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with books',
    () {
      final List<Book> expectedBooks = [
        createBook(id: 'b1'),
        createBook(id: 'b2'),
      ];

      state = state.copyWith(books: expectedBooks);
      final state2 = state.copyWith();

      expect(state.books, expectedBooks);
      expect(state2.books, expectedBooks);
    },
  );
}
