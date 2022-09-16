import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/delete_user_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final SignOutUseCase _signOutUseCase;
  late final DeleteUserUseCase _deleteUserUseCase;

  SettingsBloc({
    required SignOutUseCase signOutUseCase,
    required DeleteUserUseCase deleteUserUseCase,
    BlocStatus status = const BlocStatusInitial(),
  }) : super(
          SettingsState(status: status),
        ) {
    _signOutUseCase = signOutUseCase;
    _deleteUserUseCase = deleteUserUseCase;
    on<SettingsEventSignOut>(_signOut);
    on<SettingsEventDeleteAccount>(_deleteAccount);
  }

  Future<void> _signOut(
    SettingsEventSignOut event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _signOutUseCase.execute();
    emit(state.copyWithInfo(
      SettingsBlocInfo.userHasBeenSignedOut,
    ));
  }

  Future<void> _deleteAccount(
    SettingsEventDeleteAccount event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _deleteUserUseCase.execute(password: event.password);
      emit(state.copyWithInfo(
        SettingsBlocInfo.userAccountHasBeenDeleted,
      ));
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    }
  }

  void _manageAuthError(
    AuthError authError,
    Emitter<SettingsState> emit,
  ) {
    if (authError.code == AuthErrorCode.wrongPassword.name) {
      emit(state.copyWithError(
        SettingsBlocError.wrongPassword,
      ));
    }
  }
}
