import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SettingsState state;

  setUp(() {
    state = const SettingsState(
      status: BlocStatusInitial(),
      loggedUserEmail: null,
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
    'copy with logged user email',
    () {
      const String expectedLoggedUserEmail = 'email@example.com';

      state = state.copyWith(loggedUserEmail: expectedLoggedUserEmail);
      final state2 = state.copyWith();

      expect(state.loggedUserEmail, expectedLoggedUserEmail);
      expect(state2.loggedUserEmail, expectedLoggedUserEmail);
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
