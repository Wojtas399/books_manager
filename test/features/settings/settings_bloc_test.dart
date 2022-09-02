import 'package:app/domain/use_cases/auth/delete_user_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/features/settings/bloc/settings_bloc.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignOutUseCase extends Mock implements SignOutUseCase {}

class MockDeleteUserUseCase extends Mock implements DeleteUserUseCase {}

void main() {
  final signOutUseCase = MockSignOutUseCase();
  final deleteUserUseCase = MockDeleteUserUseCase();

  SettingsBloc createBloc() {
    return SettingsBloc(
      signOutUseCase: signOutUseCase,
      deleteUserUseCase: deleteUserUseCase,
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
    reset(deleteUserUseCase);
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
    'delete account, should call use case responsible for deleting user',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteUserUseCase.execute(password: 'password'),
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
        () => deleteUserUseCase.execute(password: 'password'),
      ).called(1);
    },
  );

  blocTest(
    'delete account, should emit appropriate info if given password is wrong',
    build: () => createBloc(),
    setUp: () {
      when(
        () => deleteUserUseCase.execute(password: 'password'),
      ).thenThrow(AuthError(authErrorCode: AuthErrorCode.wrongPassword));
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
