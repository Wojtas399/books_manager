import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app/domain/entities/auth_error.dart';
import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:app/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:app/models/avatar.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/validators/email_validator.dart';
import 'package:app/validators/password_validator.dart';
import 'package:app/validators/username_validator.dart';

class MockUsernameValidator extends Mock implements UsernameValidator {}

class MockEmailValidator extends Mock implements EmailValidator {}

class MockPasswordValidator extends Mock implements PasswordValidator {}

class MockSignUpUseCase extends Mock implements SignUpUseCase {}

void main() {
  final usernameValidator = MockUsernameValidator();
  final emailValidator = MockEmailValidator();
  final passwordValidator = MockPasswordValidator();
  final signUpUseCase = MockSignUpUseCase();

  SignUpBloc createBloc({
    Avatar avatar = const BasicAvatar(type: BasicAvatarType.red),
    String username = '',
    String email = '',
    String password = '',
  }) {
    return SignUpBloc(
      usernameValidator: usernameValidator,
      emailValidator: emailValidator,
      passwordValidator: passwordValidator,
      signUpUseCase: signUpUseCase,
      avatar: avatar,
      username: username,
      email: email,
      password: password,
    );
  }

  SignUpState createState({
    BlocStatus status = const BlocStatusInProgress(),
    Avatar avatar = const BasicAvatar(type: BasicAvatarType.red),
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
    bool isUsernameValid = false,
    bool isEmailValid = false,
    bool isPasswordValid = false,
  }) {
    return SignUpState(
      status: status,
      avatar: avatar,
      username: username,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      isUsernameValid: isUsernameValid,
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
    );
  }

  tearDown(() {
    reset(usernameValidator);
    reset(emailValidator);
    reset(passwordValidator);
    reset(signUpUseCase);
  });

  blocTest(
    'avatar changed, should update avatar',
    build: () => createBloc(),
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventAvatarChanged(
          avatar: const BasicAvatar(
            type: BasicAvatarType.green,
          ),
        ),
      );
    },
    expect: () => [
      createState(
        avatar: const BasicAvatar(type: BasicAvatarType.green),
      ),
    ],
  );

  blocTest(
    'username changed, should update username and its validation status',
    build: () => createBloc(),
    setUp: () {
      when(
        () => usernameValidator.isValid('username'),
      ).thenReturn(true);
    },
    act: (SignUpBloc bloc) {
      bloc.add(
        SignUpEventUsernameChanged(username: 'username'),
      );
    },
    expect: () => [
      createState(
        username: 'username',
        isUsernameValid: true,
      ),
    ],
  );

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
      final Avatar avatar = FileAvatar(file: File('path'));
      const String username = 'username';
      const String email = 'email@example.com';
      const String password = 'password123';

      blocTest(
        'should call use case responsible for signing up user',
        build: () => createBloc(
          avatar: avatar,
          username: username,
          email: email,
          password: password,
        ),
        setUp: () {
          when(
            () => signUpUseCase.execute(
              avatar: avatar,
              username: username,
              email: email,
              password: password,
            ),
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
            avatar: avatar,
            username: username,
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusComplete<SignUpBlocInfo>(
              info: SignUpBlocInfo.userHasBeenSignedUp,
            ),
            avatar: avatar,
            username: username,
            email: email,
            password: password,
          ),
        ],
        verify: (_) {
          verify(
            () => signUpUseCase.execute(
              avatar: avatar,
              username: username,
              email: email,
              password: password,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate error if email is already in use',
        build: () => createBloc(
          avatar: avatar,
          username: username,
          email: email,
          password: password,
        ),
        setUp: () {
          when(
            () => signUpUseCase.execute(
              avatar: avatar,
              username: username,
              email: email,
              password: password,
            ),
          ).thenThrow(AuthError.emailAlreadyInUse);
        },
        act: (SignUpBloc bloc) {
          bloc.add(
            SignUpEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            avatar: avatar,
            username: username,
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusError<SignUpBlocError>(
              error: SignUpBlocError.emailIsAlreadyTaken,
            ),
            avatar: avatar,
            username: username,
            email: email,
            password: password,
          ),
        ],
      );
    },
  );
}