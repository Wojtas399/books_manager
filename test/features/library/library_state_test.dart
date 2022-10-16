import 'package:app/domain/entities/book.dart';
import 'package:app/features/library/bloc/library_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LibraryState state;

  setUp(() {
    state = LibraryState(
      status: const BlocStatusInitial(),
      searchValue: '',
      books: null,
    );
  });

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
    'copy with search value',
    () {
      const String expectedSearchValue = 'wow';

      state = state.copyWith(searchValue: expectedSearchValue);
      final state2 = state.copyWith();

      expect(state.searchValue, expectedSearchValue);
      expect(state2.searchValue, expectedSearchValue);
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

  group(
    'books',
    () {
      final List<Book> allBooks = [
        createBook(title: 'boom', author: 'Robert Martin'),
        createBook(title: 'wow', author: 'Jack New'),
        createBook(title: 'abc', author: 'Isabelle Pixel'),
        createBook(title: 'feel', author: 'Jeremy Grom')
      ];

      test(
        'should return all books if search value is empty',
        () {
          state = state.copyWith(books: allBooks);

          final List<Book>? books = state.books;

          expect(books, allBooks);
        },
      );

      test(
        'should return books which title or author match to search value',
        () {
          const String searchValue = 'om';
          final List<Book> expectedBooks = [allBooks.first, allBooks.last];
          state = state.copyWith(
            books: allBooks,
            searchValue: searchValue,
          );

          final List<Book>? books = state.books;

          expect(books, expectedBooks);
        },
      );
    },
  );
}
