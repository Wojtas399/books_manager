import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:app/models/auth_state.dart';
import 'package:app/domain/use_cases/auth/get_auth_state_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:app/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';

class MockGetAuthStateUseCase extends Mock implements GetAuthStateUseCase {}

class MockSignInUseCase extends Mock implements SignInUseCase {}

void main() {
  final getAuthStateUseCase = MockGetAuthStateUseCase();
  final signInUseCase = MockSignInUseCase();

  SignInBloc createBloc({
    String email = '',
    String password = '',
  }) {
    return SignInBloc(
      getAuthStateUseCase: getAuthStateUseCase,
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
    'initialize, should emit appropriate info if auth state is set to signed in',
    build: () => createBloc(),
    setUp: () {
      when(
        () => getAuthStateUseCase.execute(),
      ).thenAnswer(
        (_) => Stream.value(const AuthStateSignedIn(userId: 'userId')),
      );
    },
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventInitialize(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete<SignInBlocInfo>(
          info: SignInBlocInfo.userHasBeenSignedIn,
        ),
      ),
    ],
  );

  blocTest(
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventEmailChanged(email: 'email'),
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
        const SignInEventPasswordChanged(password: 'password'),
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
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signInUseCase.execute(email: email, password: password),
          ).thenAnswer((_) async => '');
        },
        act: (SignInBloc bloc) {
          bloc.add(
            const SignInEventSubmit(),
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
        'should emit appropriate error if email is invalid',
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signInUseCase.execute(email: email, password: password),
          ).thenThrow(AuthError(authErrorCode: AuthErrorCode.invalidEmail));
        },
        act: (SignInBloc bloc) {
          bloc.add(
            const SignInEventSubmit(),
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
        'should emit appropriate error if password is invalid',
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signInUseCase.execute(email: email, password: password),
          ).thenThrow(AuthError(authErrorCode: AuthErrorCode.wrongPassword));
        },
        act: (SignInBloc bloc) {
          bloc.add(
            const SignInEventSubmit(),
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
              error: SignInBlocError.wrongPassword,
            ),
            email: email,
            password: password,
          ),
        ],
      );

      blocTest(
        'should emit appropriate error if user has not been found',
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signInUseCase.execute(email: email, password: password),
          ).thenThrow(AuthError(authErrorCode: AuthErrorCode.userNotFound));
        },
        act: (SignInBloc bloc) {
          bloc.add(
            const SignInEventSubmit(),
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

      blocTest(
        'should emit appropriate error if there is no internet connection',
        build: () => createBloc(email: email, password: password),
        setUp: () {
          when(
            () => signInUseCase.execute(email: email, password: password),
          ).thenThrow(
            NetworkError(networkErrorCode: NetworkErrorCode.lossOfConnection),
          );
        },
        act: (SignInBloc bloc) {
          bloc.add(
            const SignInEventSubmit(),
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
              error: SignInBlocError.noInternetConnection,
            ),
            email: email,
            password: password,
          ),
        ],
      );
    },
  );

  blocTest(
    'clean form, should clean email and password',
    build: () => createBloc(email: 'email', password: 'password'),
    act: (SignInBloc bloc) {
      bloc.add(
        const SignInEventCleanForm(),
      );
    },
    expect: () => [
      createState(email: '', password: ''),
    ],
  );
}
