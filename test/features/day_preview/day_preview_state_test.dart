import 'package:app/features/day_preview/bloc/day_preview_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:test/test.dart';

void main() {
  late DayPreviewState state;

  setUp(() {
    state = const DayPreviewState(
      status: BlocStatusInitial(),
      date: null,
      dayPreviewBooks: [],
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
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2022, 9, 20);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with day preview books',
    () {
      final List<DayPreviewBook> expectedDayPreviewBooks = [
        createDayPreviewBook(id: 'b1'),
        createDayPreviewBook(id: 'b2'),
      ];

      state = state.copyWith(dayPreviewBooks: expectedDayPreviewBooks);
      final state2 = state.copyWith();

      expect(state.dayPreviewBooks, expectedDayPreviewBooks);
      expect(state2.dayPreviewBooks, expectedDayPreviewBooks);
    },
  );
}
