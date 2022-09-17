import 'package:app/domain/entities/book.dart';
import 'package:app/features/reading/bloc/reading_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ReadingState state;

  setUp(() {
    state = const ReadingState(
      status: BlocStatusInitial(),
      booksInProgress: [],
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
    'copy with books in progress',
    () {
      final List<Book> expectedBooksInProgress = [
        createBook(id: 'b1', status: BookStatus.inProgress),
        createBook(id: 'b2', status: BookStatus.inProgress),
      ];

      state = state.copyWith(booksInProgress: expectedBooksInProgress);
      final state2 = state.copyWith();

      expect(state.booksInProgress, expectedBooksInProgress);
      expect(state2.booksInProgress, expectedBooksInProgress);
    },
  );
}
