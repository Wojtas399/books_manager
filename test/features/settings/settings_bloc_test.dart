import 'package:app/config/errors.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/domain/use_cases/auth/mock_change_logged_user_password_use_case.dart';
import '../../mocks/domain/use_cases/auth/mock_delete_logged_user_use_case.dart';
import '../../mocks/domain/use_cases/auth/mock_get_logged_user_email_use_case.dart';
import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/auth/mock_sign_out_use_case.dart';
import '../../mocks/domain/use_cases/user/mock_get_user_use_case.dart';
import '../../mocks/domain/use_cases/user/mock_update_user_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final getLoggedUserEmailUseCase = MockGetLoggedUserEmailUseCase();
  final getUserUseCase = MockGetUserUseCase();
  final updateUserUseCase = MockUpdateUserUseCase();
  final changeLoggedUserPasswordUseCase = MockChangeLoggedUserPasswordUseCase();
  final signOutUseCase = MockSignOutUseCase();
  final deleteLoggedUserUseCase = MockDeleteLoggedUserUseCase();

  SettingsBloc createBloc({
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
  }) {
    return SettingsBloc(
      getLoggedUserIdUseCase: getLoggedUserIdUseCase,
      getLoggedUserEmailUseCase: getLoggedUserEmailUseCase,
      getUserUseCase: getUserUseCase,
      updateUserUseCase: updateUserUseCase,
      changeLoggedUserPasswordUseCase: changeLoggedUserPasswordUseCase,
      signOutUseCase: signOutUseCase,
      deleteLoggedUserUseCase: deleteLoggedUserUseCase,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  SettingsState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? loggedUserEmail,
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
  }) {
    return SettingsState(
      status: status,
      loggedUserEmail: loggedUserEmail,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }

  tearDown(() {
    reset(getLoggedUserIdUseCase);
    reset(getLoggedUserEmailUseCase);
    reset(getUserUseCase);
    reset(updateUserUseCase);
    reset(changeLoggedUserPasswordUseCase);
    reset(signOutUseCase);
    reset(deleteLoggedUserUseCase);
  });

  group(
    'initialize',
    () {
      const String loggedUserId = 'u1';
      const String loggedUserEmail = 'email@example.com';
      final User user = createUser(
        id: loggedUserId,
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: true,
      );

      void eventCall(SettingsBloc bloc) => bloc.add(
            const SettingsEventInitialize(),
          );

      tearDown(() {
        verify(
          () => getLoggedUserIdUseCase.execute(),
        ).called(1);
        verify(
          () => getLoggedUserEmailUseCase.execute(),
        ).called(1);
      });

      blocTest(
        'logged user does not exist, should not change state',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock();
          getLoggedUserEmailUseCase.mock();
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusComplete(),
          ),
        ],
      );

      blocTest(
        'logged user exists, should get logged user data and assign them to state',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
          getLoggedUserEmailUseCase.mock(loggedUserEmail: loggedUserEmail);
          getUserUseCase.mock(user: user);
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusLoading(),
            loggedUserEmail: loggedUserEmail,
          ),
          createState(
            status: const BlocStatusComplete(),
            loggedUserEmail: loggedUserEmail,
            isDarkModeOn: true,
            isDarkModeCompatibilityWithSystemOn: true,
          ),
        ],
        verify: (_) {
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

  group(
    'switch dark mode',
    () {
      void eventCall(SettingsBloc bloc) => bloc.add(
            const SettingsEventSwitchDarkMode(isSwitched: true),
          );

      setUp(() {
        updateUserUseCase.mock();
      });

      tearDown(() {
        verify(
          () => getLoggedUserIdUseCase.execute(),
        ).called(1);
      });

      blocTest(
        'should do nothing if logged user id is null',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: null);
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => updateUserUseCase.execute(
              userId: any(named: 'userId'),
              isDarkModeOn: true,
            ),
          );
        },
      );

      blocTest(
        'should update state and then should call use case responsible for updating theme settings',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            isDarkModeOn: true,
          ),
        ],
        verify: (_) {
          verify(
            () => updateUserUseCase.execute(
              userId: 'u1',
              isDarkModeOn: true,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should set previous value if use case throws error',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
          updateUserUseCase.mock(throwable: 'Error...');
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            isDarkModeOn: true,
          ),
          createState(
            status: const BlocStatusComplete(),
            isDarkModeOn: false,
          ),
        ],
        verify: (_) {
          verify(
            () => updateUserUseCase.execute(
              userId: 'u1',
              isDarkModeOn: true,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'switch dark mode compatibility with system',
    () {
      void eventCall(SettingsBloc bloc) => bloc.add(
            const SettingsEventSwitchDarkModeCompatibilityWithSystem(
              isSwitched: true,
            ),
          );

      setUp(() {
        updateUserUseCase.mock();
      });

      tearDown(() {
        verify(
          () => getLoggedUserIdUseCase.execute(),
        ).called(1);
      });

      blocTest(
        'should do nothing if logged user id is null',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: null);
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [],
        verify: (_) {
          verifyNever(
            () => updateUserUseCase.execute(
              userId: any(named: 'userId'),
              isDarkModeCompatibilityWithSystemOn: true,
            ),
          );
        },
      );

      blocTest(
        'should update state and then should call use case responsible for updating theme settings',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            isDarkModeCompatibilityWithSystemOn: true,
          ),
        ],
        verify: (_) {
          verify(
            () => updateUserUseCase.execute(
              userId: 'u1',
              isDarkModeCompatibilityWithSystemOn: true,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should set previous value if use case throws error',
        build: () => createBloc(),
        setUp: () {
          getLoggedUserIdUseCase.mock(loggedUserId: 'u1');
          updateUserUseCase.mock(throwable: 'Error...');
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusComplete(),
            isDarkModeCompatibilityWithSystemOn: true,
          ),
          createState(
            status: const BlocStatusComplete(),
            isDarkModeCompatibilityWithSystemOn: false,
          ),
        ],
        verify: (_) {
          verify(
            () => updateUserUseCase.execute(
              userId: 'u1',
              isDarkModeCompatibilityWithSystemOn: true,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'change password',
    () {
      const String currentPassword = 'currentPassword';
      const String newPassword = 'newPassword';

      void eventCall(SettingsBloc bloc) => bloc.add(
            const SettingsEventChangePassword(
              currentPassword: currentPassword,
              newPassword: newPassword,
            ),
          );

      tearDown(() {
        verify(
          () => changeLoggedUserPasswordUseCase.execute(
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
        ).called(1);
      });

      blocTest(
        'should call use case responsible for changing logged user password',
        build: () => createBloc(),
        setUp: () {
          changeLoggedUserPasswordUseCase.mock();
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
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
      );

      blocTest(
        'should emit appropriate error if given current password is wrong',
        build: () => createBloc(),
        setUp: () {
          changeLoggedUserPasswordUseCase.mock(
            throwable: const AuthError(code: AuthErrorCode.wrongPassword),
          );
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
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

      void eventCall(SettingsBloc bloc) => bloc.add(
            const SettingsEventDeleteAccount(password: password),
          );

      blocTest(
        'should call use case responsible for deleting logged user',
        build: () => createBloc(),
        setUp: () {
          deleteLoggedUserUseCase.mock();
        },
        act: (SettingsBloc bloc) => eventCall(bloc),
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
        act: (SettingsBloc bloc) => eventCall(bloc),
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
        act: (SettingsBloc bloc) => eventCall(bloc),
        expect: () => [
          createState(
            status: const BlocStatusLoading(),
          ),
          createState(
            status: const BlocStatusLoggedUserNotFound(),
          ),
        ],
      );
    },
  );
}
