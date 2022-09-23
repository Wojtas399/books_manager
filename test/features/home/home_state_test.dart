import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeState state;

  setUp(() {
    state = const HomeState(
      status: BlocStatusInitial(),
      currentPageIndex: 0,
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
    'copy with current page index',
    () {
      const int expectedIndex = 2;

      state = state.copyWith(currentPageIndex: expectedIndex);
      final state2 = state.copyWith();

      expect(state.currentPageIndex, expectedIndex);
      expect(state2.currentPageIndex, expectedIndex);
    },
  );
}
