import 'package:app/features/home/bloc/home_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeState state;

  setUp(() {
    state = const HomeState(
      status: BlocStatusInitial(),
      currentPageIndex: 0,
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
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

  test(
    'copy with is dark mode on',
    () {
      const bool expectedValue = true;

      state = state.copyWith(isDarkModeOn: expectedValue);
      final state2 = state.copyWith();

      expect(state.isDarkModeOn, expectedValue);
      expect(state2.isDarkModeOn, expectedValue);
    },
  );

  test(
    'copy with is dark mode compatibility with system on',
    () {
      const bool expectedValue = true;

      state = state.copyWith(
        isDarkModeCompatibilityWithSystemOn: expectedValue,
      );
      final state2 = state.copyWith();

      expect(state.isDarkModeCompatibilityWithSystemOn, expectedValue);
      expect(state2.isDarkModeCompatibilityWithSystemOn, expectedValue);
    },
  );
}
