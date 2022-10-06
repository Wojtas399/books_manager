import 'package:app/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SignInState state;

  setUp(() {
    state = const SignInState(
      status: BlocStatusInitial(),
      email: '',
      password: '',
    );
  });

  test(
    'is button disabled, should be true if email is empty',
    () {
      const String email = '';
      const String password = 'password';

      state = state.copyWith(
        email: email,
        password: password,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if password is empty',
    () {
      const String email = 'email';
      const String password = '';

      state = state.copyWith(
        email: email,
        password: password,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be false if email and password are not empty',
    () {
      const String email = 'email';
      const String password = 'password';

      state = state.copyWith(
        email: email,
        password: password,
      );

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
    'copy with password',
    () {
      const String expectedPassword = 'password';

      state = state.copyWith(password: expectedPassword);
      final state2 = state.copyWith();

      expect(state.password, expectedPassword);
      expect(state2.password, expectedPassword);
    },
  );
}
