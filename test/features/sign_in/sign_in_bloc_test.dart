import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:app/domain/entities/auth_error.dart';
import 'package:app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:app/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:app/models/bloc_status.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

void main() {
  final signInUseCase = MockSignInUseCase();

  SignInBloc createBloc({
    String email = '',
    String password = '',
  }) {
    return SignInBloc(
      signInUseCase: signInUseCase,
      email: email,
      password: password,
    );
  }

  SignInState createState({
    BlocStatus status = const BlocStatusInProgress(),
    String email = '',
    String password = '',
  }) {
    return SignInState(
      status: status,
      email: email,
      password: password,
    );
  }

  tearDown(() {
    reset(signInUseCase);
  });

  blocTest(
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(
        SignInEventEmailChanged(email: 'email'),
      );
    },
    expect: () => [
      createState(email: 'email'),
    ],
  );

  blocTest(
    'password changed, should update password in state',
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(
        SignInEventPasswordChanged(password: 'password'),
      );
    },
    expect: () => [
      createState(password: 'password'),
    ],
  );

  group(
    'submit',
    () {
      const String email = 'email@example.com';
      const String password = 'password123';

      blocTest(
        'should call use case responsible for signing in user',
        build: () => createBloc(
          email: email,
          password: password,
        ),
        setUp: () {
          when(
            () => signInUseCase.execute(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async => '');
        },
        act: (SignInBloc bloc) {
          bloc.add(
            SignInEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusComplete<SignInBlocInfo>(
              info: SignInBlocInfo.userHasBeenSignedIn,
            ),
            email: email,
            password: password,
          ),
        ],
        verify: (_) {
          verify(
            () => signInUseCase.execute(
              email: email,
              password: password,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate info if email is invalid',
        build: () => createBloc(
          email: email,
          password: password,
        ),
        setUp: () {
          when(
            () => signInUseCase.execute(
              email: email,
              password: password,
            ),
          ).thenThrow(AuthError.invalidEmail);
        },
        act: (SignInBloc bloc) {
          bloc.add(
            SignInEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusError<SignInBlocError>(
              error: SignInBlocError.invalidEmail,
            ),
            email: email,
            password: password,
          ),
        ],
      );

      blocTest(
        'should emit appropriate info if password is invalid',
        build: () => createBloc(
          email: email,
          password: password,
        ),
        setUp: () {
          when(
            () => signInUseCase.execute(
              email: email,
              password: password,
            ),
          ).thenThrow(AuthError.invalidPassword);
        },
        act: (SignInBloc bloc) {
          bloc.add(
            SignInEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusError<SignInBlocError>(
              error: SignInBlocError.invalidPassword,
            ),
            email: email,
            password: password,
          ),
        ],
      );

      blocTest(
        'should emit appropriate info if user has not been found',
        build: () => createBloc(
          email: email,
          password: password,
        ),
        setUp: () {
          when(
            () => signInUseCase.execute(
              email: email,
              password: password,
            ),
          ).thenThrow(AuthError.userNotFound);
        },
        act: (SignInBloc bloc) {
          bloc.add(
            SignInEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
            password: password,
          ),
          createState(
            status: const BlocStatusError<SignInBlocError>(
              error: SignInBlocError.userNotFound,
            ),
            email: email,
            password: password,
          ),
        ],
      );
    },
  );
}
