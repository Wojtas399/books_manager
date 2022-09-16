import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:app/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:app/validators/email_validator.dart';
import 'package:app/validators/password_validator.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmailValidator extends Mock implements EmailValidator {}

class MockPasswordValidator extends Mock implements PasswordValidator {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  final emailValidator = MockEmailValidator();
  final passwordValidator = MockPasswordValidator();
  final signUpUseCase = MockSignUpUseCase();

  SignUpBloc createBloc({
    String email = '',
    String password = '',
  }) {
    return SignUpBloc(
      emailValidator: emailValidator,
      passwordValidator: passwordValidator,
      signUpUseCase: signUpUseCase,
      email: email,
      password: password,
    );
  }

  SignUpState createState({
    BlocStatus status = const BlocStatusInProgress(),
    String email = '',
    String password = '',
    String passwordConfirmation = '',
    bool isEmailValid = false,
    bool isPasswordValid = false,
  }) {
    return SignUpState(
      status: status,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
    );
  }

  tearDown(() {
    reset(emailValidator);
    reset(passwordValidator);
    reset(signUpUseCase);
  });

  blocTest(
    'email changed, should update email and its validation status',
    build: () => createBloc(),
    setUp: () {
      when(
        () => emailValidator.isValid('email'),
      ).thenReturn(true);
    },
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventEmailChanged(email: 'email'),
      );
    },
    expect: () => [
      createState(
        email: 'email',
        isEmailValid: true,
      ),
    ],
  );

  blocTest(
    'password changed, should update password and its validation status',
    build: () => createBloc(),
    setUp: () {
      when(
        () => passwordValidator.isValid('password'),
      ).thenReturn(true);
    },
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventPasswordChanged(password: 'password'),
      );
    },
    expect: () => [
      createState(
        password: 'password',
        isPasswordValid: true,
      ),
    ],
  );

  blocTest(
    'password confirmation changed, should update password confirmation in state',
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventPasswordConfirmationChanged(
          passwordConfirmation: 'passwordConfirmation',
        ),
      );
    },
    expect: () => [
      createState(
        passwordConfirmation: 'passwordConfirmation',
      ),
    ],
  );

  group(
    'submit',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      blocTest(
        'should call use case responsible for signing up user',
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signUpUseCase.execute(email: email, password: password),
          ).thenAnswer((_) async => '');
        },
        act: (SignUpBloc bloc) {
          bloc.add(
            SignUpEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusComplete<SignUpBlocInfo>(
              info: SignUpBlocInfo.userHasBeenSignedUp,
            ),
            email: email,
            password: password,
          ),
        ],
        verify: (_) {
          verify(
            () => signUpUseCase.execute(email: email, password: password),
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate error if email is already in use',
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signUpUseCase.execute(email: email, password: password),
          ).thenThrow(
            const AuthError(code: AuthErrorCode.emailAlreadyInUse),
          );
        },
        act: (SignUpBloc bloc) {
          bloc.add(
            SignUpEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusError<SignUpBlocError>(
              error: SignUpBlocError.emailIsAlreadyTaken,
            ),
            email: email,
            password: password,
          ),
        ],
      );

      blocTest(
        'should emit appropriate error if there is no internet connection',
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signUpUseCase.execute(email: email, password: password),
          ).thenThrow(
            const NetworkError(code: NetworkErrorCode.lossOfConnection),
          );
        },
        act: (SignUpBloc bloc) {
          bloc.add(
            SignUpEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusLossOfInternetConnection(),
            email: email,
            password: password,
          ),
        ],
      );
    },
  );
}
