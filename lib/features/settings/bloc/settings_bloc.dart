import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final SignOutUseCase _signOutUseCase;
  late final DeleteLoggedUserUseCase _deleteLoggedUserUseCase;

  SettingsBloc({
    required SignOutUseCase signOutUseCase,
    required DeleteLoggedUserUseCase deleteLoggedUserUseCase,
    BlocStatus status = const BlocStatusInitial(),
  }) : super(
          SettingsState(status: status),
        ) {
    _signOutUseCase = signOutUseCase;
    _deleteLoggedUserUseCase = deleteLoggedUserUseCase;
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
      await _tryDeleteLoggedUserAccount(event.password, emit);
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    } on NetworkError catch (networkError) {
      _manageNetworkError(networkError, emit);
    }
  }

  Future<void> _tryDeleteLoggedUserAccount(
    String password,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _deleteLoggedUserUseCase.execute(password: password);
    emit(state.copyWithInfo(
      SettingsBlocInfo.userAccountHasBeenDeleted,
    ));
  }

  void _manageAuthError(
    AuthError authError,
    Emitter<SettingsState> emit,
  ) {
    if (authError.code == AuthErrorCode.wrongPassword) {
      emit(state.copyWithError(
        SettingsBlocError.wrongPassword,
      ));
    } else if (authError.code == AuthErrorCode.userNotFound) {
      emit(state.copyWith(
        status: const BlocStatusLoggedUserNotFound(),
      ));
    }
  }

  void _manageNetworkError(
    NetworkError networkError,
    Emitter<SettingsState> emit,
  ) {
    if (networkError.code == NetworkErrorCode.lossOfConnection) {
      emit(state.copyWith(
        status: const BlocStatusLossOfInternetConnection(),
      ));
    }
  }
}
