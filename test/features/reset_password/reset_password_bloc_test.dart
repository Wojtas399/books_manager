import 'package:app/domain/use_cases/auth/send_reset_password_email_use_case.dart';
import 'package:app/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendResetPasswordEmailUseCase extends Mock
    implements SendResetPasswordEmailUseCase {}

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
          when(
            () => sendResetPasswordEmailUseCase.execute(email: email),
          ).thenAnswer((_) async => '');
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
          when(
            () => sendResetPasswordEmailUseCase.execute(email: email),
          ).thenThrow(AuthError(authErrorCode: AuthErrorCode.invalidEmail));
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
          when(
            () => sendResetPasswordEmailUseCase.execute(email: email),
          ).thenThrow(AuthError(authErrorCode: AuthErrorCode.userNotFound));
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
        'should emit appropriate info if connection has been lost',
        build: () => createBloc(email: email),
        setUp: () {
          when(
            () => sendResetPasswordEmailUseCase.execute(email: email),
          ).thenThrow(
            NetworkError(networkErrorCode: NetworkErrorCode.lossOfConnection),
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
              error: ResetPasswordBlocError.lossOfConnection,
            ),
            email: email,
          ),
        ],
      );
    },
  );
}
