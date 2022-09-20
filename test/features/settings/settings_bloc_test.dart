import 'package:app/config/errors.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/use_cases/auth/mock_delete_logged_user_use_case.dart';
import '../../mocks/use_cases/auth/mock_sign_out_use_case.dart';

void main() {
  final signOutUseCase = MockSignOutUseCase();
  final deleteLoggedUserUseCase = MockDeleteLoggedUserUseCase();

  SettingsBloc createBloc() {
    return SettingsBloc(
      signOutUseCase: signOutUseCase,
      deleteLoggedUserUseCase: deleteLoggedUserUseCase,
    );
  }

  SettingsState createState({
    BlocStatus status = const BlocStatusInProgress(),
  }) {
    return SettingsState(
      status: status,
    );
  }

  tearDown(() {
    reset(signOutUseCase);
    reset(deleteLoggedUserUseCase);
  });

  blocTest(
    'sign out, should call use case responsible for signing out user',
    build: () => createBloc(),
    setUp: () {
      signOutUseCase.mock();
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        SettingsEventSignOut(),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusLoading(),
      ),
      createState(
        status: const BlocStatusComplete<SettingsBlocInfo>(
          info: SettingsBlocInfo.userHasBeenSignedOut,
        ),
      ),
    ],
    verify: (_) {
      verify(
        () => signOutUseCase.execute(),
      ).called(1);
    },
  );

  group(
    'delete account',
    () {
      const String password = 'password';

      blocTest(
        'should call use case responsible for deleting logged user',
        build: () => createBloc(),
        setUp: () {
          deleteLoggedUserUseCase.mock();
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            SettingsEventDeleteAccount(password: password),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete<SettingsBlocInfo>(
              info: SettingsBlocInfo.userAccountHasBeenDeleted,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => deleteLoggedUserUseCase.execute(password: password),
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate error if given password is wrong',
        build: () => createBloc(),
        setUp: () {
          deleteLoggedUserUseCase.mock(
            throwable: const AuthError(code: AuthErrorCode.wrongPassword),
          );
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            SettingsEventDeleteAccount(password: password),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusError<SettingsBlocError>(
              error: SettingsBlocError.wrongPassword,
            ),
          ),
        ],
      );

      blocTest(
        'should emit appropriate state if logged user has not been found',
        build: () => createBloc(),
        setUp: () {
          deleteLoggedUserUseCase.mock(
            throwable: const AuthError(code: AuthErrorCode.userNotFound),
          );
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            SettingsEventDeleteAccount(password: password),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusLoggedUserNotFound(),
          ),
        ],
      );

      blocTest(
        'should emit appropriate state if device has not internet connection',
        build: () => createBloc(),
        setUp: () {
          deleteLoggedUserUseCase.mock(
            throwable: const NetworkError(
              code: NetworkErrorCode.lossOfConnection,
            ),
          );
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            SettingsEventDeleteAccount(password: password),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusLossOfInternetConnection(),
          ),
        ],
      );
    },
  );
}
