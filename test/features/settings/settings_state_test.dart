import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/models/bloc_status.dart';

void main() {
  late SettingsState state;

  setUp(() {
    state = const SettingsState(
      status: BlocStatusInitial(),
    );
  });

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with info',
    () {
      const SettingsBlocInfo expectedInfo =
          SettingsBlocInfo.userHasBeenSignedOut;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<SettingsBlocInfo>(info: expectedInfo),
      );
    },
  );

  test(
    'copy with error',
    () {
      const SettingsBlocError expectedError = SettingsBlocError.wrongPassword;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<SettingsBlocError>(error: expectedError),
      );
    },
  );
}
