import 'package:app/config/errors.dart';
import 'package:app/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_send_reset_password_email_use_case.dart';

void main() {
  final sendResetPasswordEmailUseCase = MockSendResetPasswordEmailUseCase();

  ResetPasswordBloc createBloc({
    String email = '',
  }) {
    return ResetPasswordBloc(
      sendResetPasswordEmailUseCase: sendResetPasswordEmailUseCase,
      email: email,
    );
  }

  ResetPasswordState createState({
    BlocStatus status = const BlocStatusInProgress(),
    String email = '',
  }) {
    return ResetPasswordState(
      status: status,
      email: email,
    );
  }

  tearDown(() {
    reset(sendResetPasswordEmailUseCase);
  });

  blocTest(
    'email changed, should update email in state',
    build: () => createBloc(),
    act: (ResetPasswordBloc bloc) {
      bloc.add(
        const ResetPasswordEventEmailChanged(email: 'email'),
      );
    },
    expect: () => [
      createState(
        email: 'email',
      ),
    ],
  );

  group(
    'submit',
    () {
      const String email = 'email@example.com';

      blocTest(
        'should call use case responsible for sending password reset email',
        build: () => createBloc(email: email),
        setUp: () {
          sendResetPasswordEmailUseCase.mock();
        },
        act: (ResetPasswordBloc bloc) {
          bloc.add(
            const ResetPasswordEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
          ),
          createState(
            status: const BlocStatusComplete<ResetPasswordBlocInfo>(
              info: ResetPasswordBlocInfo.emailHasBeenSent,
            ),
            email: email,
          ),
        ],
        verify: (_) {
          verify(
            () => sendResetPasswordEmailUseCase.execute(email: email),
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate info if email is invalid',
        build: () => createBloc(email: email),
        setUp: () {
          sendResetPasswordEmailUseCase.mock(
            throwable: const AuthError(code: AuthErrorCode.invalidEmail),
          );
        },
        act: (ResetPasswordBloc bloc) {
          bloc.add(
            const ResetPasswordEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
          ),
          createState(
            status: const BlocStatusError<ResetPasswordBlocError>(
              error: ResetPasswordBlocError.invalidEmail,
            ),
            email: email,
          ),
        ],
      );

      blocTest(
        'should emit appropriate info if user has not been found',
        build: () => createBloc(email: email),
        setUp: () {
          sendResetPasswordEmailUseCase.mock(
            throwable: const AuthError(code: AuthErrorCode.userNotFound),
          );
        },
        act: (ResetPasswordBloc bloc) {
          bloc.add(
            const ResetPasswordEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
          ),
          createState(
            status: const BlocStatusError<ResetPasswordBlocError>(
              error: ResetPasswordBlocError.userNotFound,
            ),
            email: email,
          ),
        ],
      );

      blocTest(
        'should emit appropriate info if there is no internet connection',
        build: () => createBloc(email: email),
        setUp: () {
          sendResetPasswordEmailUseCase.mock(
            throwable: const NetworkError(
              code: NetworkErrorCode.lossOfConnection,
            ),
          );
        },
        act: (ResetPasswordBloc bloc) {
          bloc.add(
            const ResetPasswordEventSubmit(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
            email: email,
          ),
          createState(
            status: const BlocStatusLossOfInternetConnection(),
            email: email,
          ),
        ],
      );
    },
  );
}
