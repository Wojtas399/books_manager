import 'package:app/config/errors.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/use_cases/auth/mock_change_logged_user_password_use_case.dart';
import '../../mocks/use_cases/auth/mock_delete_logged_user_use_case.dart';
import '../../mocks/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/use_cases/auth/mock_sign_out_use_case.dart';
import '../../mocks/use_cases/user/mock_get_user_use_case.dart';
import '../../mocks/use_cases/user/mock_load_user_use_case.dart';
import '../../mocks/use_cases/user/mock_update_theme_settings_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final loadUserUseCase = MockLoadUserUseCase();
  final getUserUseCase = MockGetUserUseCase();
  final updateThemeSettingsUseCase = MockUpdateThemeSettingsUseCase();
  final changeLoggedUserPasswordUseCase = MockChangeLoggedUserPasswordUseCase();
  final signOutUseCase = MockSignOutUseCase();
  final deleteLoggedUserUseCase = MockDeleteLoggedUserUseCase();

  SettingsBloc createBloc({
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
  }) {
    return SettingsBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      loadUserUseCase: loadUserUseCase,
      getUserUseCase: getUserUseCase,
      updateThemeSettingsUseCase: updateThemeSettingsUseCase,
      changeLoggedUserPasswordUseCase: changeLoggedUserPasswordUseCase,
      signOutUseCase: signOutUseCase,
      deleteLoggedUserUseCase: deleteLoggedUserUseCase,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  SettingsState createState({
    BlocStatus status = const BlocStatusInProgress(),
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
  }) {
    return SettingsState(
      status: status,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(updateThemeSettingsUseCase);
    reset(changeLoggedUserPasswordUseCase);
    reset(signOutUseCase);
    reset(deleteLoggedUserUseCase);
  });

  group(
    'initialize',
    () {
      const String loggedUserId = 'u1';
      final User user = createUser(
        id: loggedUserId,
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: true,
      );

      blocTest(
        'logged user does not exist, should emit logged user not found status',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: null);
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            const SettingsEventInitialize(),
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
        verify: (_) {
          verify(
            () => getLoggedUserIdUseCase.execute(),
          ).called(1);
        },
      );

      blocTest(
        'logged user exists, should call use case responsible for loading logged user, should get logged user data and assign them to state',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          loadUserUseCase.mock();
          getUserUseCase.mock(user: user);
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            const SettingsEventInitialize(),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
            isDarkModeOn: true,
            isDarkModeCompatibilityWithSystemOn: true,
          ),
        ],
        verify: (_) {
          verify(
            () => loadUserUseCase.execute(userId: loggedUserId),
          ).called(1);
          verify(
            () => getUserUseCase.execute(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'user updated, should update dark mode settings in state',
    build: () => createBloc(),
    act: (SettingsBloc bloc) {
      bloc.add(
        SettingsEventUserUpdated(
          user: createUser(
            isDarkModeOn: false,
            isDarkModeCompatibilityWithSystemOn: true,
          ),
        ),
      );
    },
    expect: () => [
      createState(
        status: const BlocStatusComplete(),
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: true,
      ),
    ],
  );

  blocTest(
    'switch dark mode, should do nothing if logged user id is null',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: null);
      updateThemeSettingsUseCase.mock();
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        const SettingsEventSwitchDarkMode(isSwitched: true),
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => getLoggedUserIdUseCase.execute(),
      ).called(1);
      verifyNever(
        () => updateThemeSettingsUseCase.execute(
          userId: any(named: 'userId'),
          isDarkModeOn: true,
        ),
      );
    },
  );

  blocTest(
    'switch dark mode, should call use case responsible for updating theme settings',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      updateThemeSettingsUseCase.mock();
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        const SettingsEventSwitchDarkMode(isSwitched: true),
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => updateThemeSettingsUseCase.execute(
          userId: 'u1',
          isDarkModeOn: true,
        ),
      ).called(1);
    },
  );

  blocTest(
    'switch dark mode compatibility with system, should do nothing if logged user id is null',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: null);
      updateThemeSettingsUseCase.mock();
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        const SettingsEventSwitchDarkModeCompatibilityWithSystem(
          isSwitched: true,
        ),
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => getLoggedUserIdUseCase.execute(),
      ).called(1);
      verifyNever(
        () => updateThemeSettingsUseCase.execute(
          userId: any(named: 'userId'),
          isDarkModeCompatibilityWithSystemOn: true,
        ),
      );
    },
  );

  blocTest(
    'switch dark mode compatibility with system, should call use case responsible for updating theme settings',
    build: () => createBloc(),
    setUp: () {
      getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
      updateThemeSettingsUseCase.mock();
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        const SettingsEventSwitchDarkModeCompatibilityWithSystem(
          isSwitched: true,
        ),
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => updateThemeSettingsUseCase.execute(
          userId: 'u1',
          isDarkModeCompatibilityWithSystemOn: true,
        ),
      ).called(1);
    },
  );

  group(
    'change password',
    () {
      const String currentPassword = 'currentPassword';
      const String newPassword = 'newPassword';

      blocTest(
        'should call use case responsible for changing logged user password',
        build: () => createBloc(),
        setUp: () {
          changeLoggedUserPasswordUseCase.mock();
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            const SettingsEventChangePassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          );
        },
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete<SettingsBlocInfo>(
              info: SettingsBlocInfo.passwordHasBeenChanged,
            ),
          ),
        ],
        verify: (_) {
          verify(
            () => changeLoggedUserPasswordUseCase.execute(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit appropriate error if given current password is wrong',
        build: () => createBloc(),
        setUp: () {
          changeLoggedUserPasswordUseCase.mock(
            throwable: const AuthError(code: AuthErrorCode.wrongPassword),
          );
        },
        act: (SettingsBloc bloc) {
          bloc.add(
            const SettingsEventChangePassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
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
        verify: (_) {
          verify(
            () => changeLoggedUserPasswordUseCase.execute(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'sign out, should call use case responsible for signing out user',
    build: () => createBloc(),
    setUp: () {
      signOutUseCase.mock();
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        const SettingsEventSignOut(),
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
            const SettingsEventDeleteAccount(password: password),
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
            const SettingsEventDeleteAccount(password: password),
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
            const SettingsEventDeleteAccount(password: password),
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
            const SettingsEventDeleteAccount(password: password),
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
