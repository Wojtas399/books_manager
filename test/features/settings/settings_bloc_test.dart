import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockDeleteLoggedUserUseCase extends Mock
    implements DeleteLoggedUserUseCase {}

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
      when(
        () => signOutUseCase.execute(),
      ).thenAnswer((_) async => '');
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

  blocTest(
    'delete account, should call use case responsible for deleting logged user',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteLoggedUserUseCase.execute(password: 'password'),
      ).thenAnswer((_) async => '');
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        SettingsEventDeleteAccount(password: 'password'),
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
        () => deleteLoggedUserUseCase.execute(password: 'password'),
      ).called(1);
    },
  );

  blocTest(
    'delete account, should emit appropriate info if given password is wrong',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteLoggedUserUseCase.execute(password: 'password'),
      ).thenThrow(
        const AuthError(code: AuthErrorCode.wrongPassword),
      );
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        SettingsEventDeleteAccount(password: 'password'),
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
}
