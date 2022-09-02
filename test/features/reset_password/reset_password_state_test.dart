import 'package:app/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ResetPasswordState state;

  setUp(() {
    state = const ResetPasswordState(
      status: BlocStatusInitial(),
      email: '',
    );
  });

  test(
    'is button disabled, should be true if email is empty',
    () {
      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be false if email is not empty',
    () {
      const String email = 'email@example.com';

      state = state.copyWith(email: email);

      expect(state.isButtonDisabled, false);
    },
  );

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
    'copy with email',
    () {
      const String expectedEmail = 'email@example.com';

      state = state.copyWith(email: expectedEmail);
      final state2 = state.copyWith();

      expect(state.email, expectedEmail);
      expect(state2.email, expectedEmail);
    },
  );

  test(
    'copy with info',
    () {
      const ResetPasswordBlocInfo expectedInfo =
          ResetPasswordBlocInfo.emailHasBeenSent;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<ResetPasswordBlocInfo>(
          info: expectedInfo,
        ),
      );
    },
  );

  test(
    'copy with error',
    () {
      const ResetPasswordBlocError expectedError =
          ResetPasswordBlocError.userNotFound;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<ResetPasswordBlocError>(
          error: expectedError,
        ),
      );
    },
  );
}
