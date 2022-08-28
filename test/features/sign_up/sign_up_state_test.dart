import 'package:app/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SignUpState state;

  setUp(() {
    state = const SignUpState(
      status: BlocStatusInitial(),
      email: '',
      password: '',
      passwordConfirmation: '',
      isEmailValid: false,
      isPasswordValid: false,
    );
  });

  test(
    'is password confirmation valid, should be true if passwords are the same',
    () {
      const String password = 'password123';
      const String passwordConfirmation = 'password123';

      state = state.copyWith(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      expect(state.isPasswordConfirmationValid, true);
    },
  );

  test(
    'is password confirmation valid, should be false if passwords are not the same',
    () {
      const String password = 'password123';
      const String passwordConfirmation = 'password';

      state = state.copyWith(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      expect(state.isPasswordConfirmationValid, false);
    },
  );

  test(
    'is button disabled, should be true if email is invalid',
    () {
      state = state.copyWith(
        password: 'password',
        passwordConfirmation: 'password',
        isEmailValid: false,
        isPasswordValid: true,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if password is invalid',
    () {
      state = state.copyWith(
        password: 'password',
        passwordConfirmation: 'password',
        isEmailValid: true,
        isPasswordValid: false,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be true if passwords are not the same',
    () {
      state = state.copyWith(
        password: 'password123',
        passwordConfirmation: 'password',
        isEmailValid: true,
        isPasswordValid: true,
      );

      expect(state.isButtonDisabled, true);
    },
  );

  test(
    'is button disabled, should be false if all params are valid and passwords are the same',
    () {
      state = state.copyWith(
        password: 'password',
        passwordConfirmation: 'password',
        isEmailValid: true,
        isPasswordValid: true,
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

  test(
    'copy with password confirmation',
    () {
      const String expectedPasswordConfirmation = 'password confirmation';

      state = state.copyWith(
        passwordConfirmation: expectedPasswordConfirmation,
      );
      final state2 = state.copyWith();

      expect(state.passwordConfirmation, expectedPasswordConfirmation);
      expect(state2.passwordConfirmation, expectedPasswordConfirmation);
    },
  );

  test(
    'copy with is email valid',
    () {
      const bool expectedValue = true;

      state = state.copyWith(isEmailValid: expectedValue);
      final state2 = state.copyWith();

      expect(state.isEmailValid, expectedValue);
      expect(state2.isEmailValid, expectedValue);
    },
  );

  test(
    'copy with is password valid',
    () {
      const bool expectedValue = true;

      state = state.copyWith(isPasswordValid: expectedValue);
      final state2 = state.copyWith();

      expect(state.isPasswordValid, expectedValue);
      expect(state2.isPasswordValid, expectedValue);
    },
  );

  test(
    'copy with info',
    () {
      const SignUpBlocInfo expectedInfo = SignUpBlocInfo.userHasBeenSignedUp;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<SignUpBlocInfo>(info: expectedInfo),
      );
    },
  );

  test(
    'copy with error',
    () {
      const SignUpBlocError expectedError = SignUpBlocError.emailIsAlreadyTaken;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<SignUpBlocError>(error: expectedError),
      );
    },
  );
}
