import 'dart:async';

import 'package:app/config/errors.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/use_cases/auth/change_logged_user_password_use_case.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:app/domain/use_cases/user/update_user_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/models/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends CustomBloc<SettingsEvent, SettingsState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final GetUserUseCase _getUserUseCase;
  late final UpdateUserUseCase _updateUserUseCase;
  late final ChangeLoggedUserPasswordUseCase _changeLoggedUserPasswordUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final DeleteLoggedUserUseCase _deleteLoggedUserUseCase;
  StreamSubscription<User>? _userListener;

  SettingsBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required GetUserUseCase getUserUseCase,
    required UpdateUserUseCase updateUserUseCase,
    required ChangeLoggedUserPasswordUseCase changeLoggedUserPasswordUseCase,
    required SignOutUseCase signOutUseCase,
    required DeleteLoggedUserUseCase deleteLoggedUserUseCase,
    BlocStatus status = const BlocStatusInitial(),
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
  }) : super(
          SettingsState(
            status: status,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
          ),
        ) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _getUserUseCase = getUserUseCase;
    _updateUserUseCase = updateUserUseCase;
    _changeLoggedUserPasswordUseCase = changeLoggedUserPasswordUseCase;
    _signOutUseCase = signOutUseCase;
    _deleteLoggedUserUseCase = deleteLoggedUserUseCase;
    on<SettingsEventInitialize>(_initialize);
    on<SettingsEventUserUpdated>(_userUpdated);
    on<SettingsEventSwitchDarkMode>(_switchDarkMode);
    on<SettingsEventSwitchDarkModeCompatibilityWithSystem>(
      _switchDarkModeCompatibilityWithSystem,
    );
    on<SettingsEventChangePassword>(_changePassword);
    on<SettingsEventSignOut>(_signOut);
    on<SettingsEventDeleteAccount>(_deleteAccount);
  }

  @override
  Future<void> close() async {
    super.close();
    _userListener?.cancel();
  }

  Future<void> _initialize(
    SettingsEventInitialize event,
    Emitter<SettingsState> emit,
  ) async {
    emitLoadingStatus(emit);
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emitLoggedUserNotFoundStatus(emit);
    } else {
      _setUserListener(loggedUserId);
    }
  }

  void _userUpdated(
    SettingsEventUserUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(
      status: const BlocStatusComplete(),
      isDarkModeOn: event.user.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.user.isDarkModeCompatibilityWithSystemOn,
    ));
  }

  Future<void> _switchDarkMode(
    SettingsEventSwitchDarkMode event,
    Emitter<SettingsState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      return;
    }
    final bool previousValue = state.isDarkModeOn;
    emit(state.copyWith(
      isDarkModeOn: event.isSwitched,
    ));
    try {
      await _updateUserUseCase.execute(
        userId: loggedUserId,
        isDarkModeOn: event.isSwitched,
      );
    } catch (_) {
      emit(state.copyWith(
        isDarkModeOn: previousValue,
      ));
    }
  }

  Future<void> _switchDarkModeCompatibilityWithSystem(
    SettingsEventSwitchDarkModeCompatibilityWithSystem event,
    Emitter<SettingsState> emit,
  ) async {
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      return;
    }
    final bool previousValue = state.isDarkModeCompatibilityWithSystemOn;
    emit(state.copyWith(
      isDarkModeCompatibilityWithSystemOn: event.isSwitched,
    ));
    try {
      await _updateUserUseCase.execute(
        userId: loggedUserId,
        isDarkModeCompatibilityWithSystemOn: event.isSwitched,
      );
    } catch (_) {
      emit(state.copyWith(
        isDarkModeCompatibilityWithSystemOn: previousValue,
      ));
    }
  }

  Future<void> _changePassword(
    SettingsEventChangePassword event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _tryChangeLoggedUserPassword(
        event.currentPassword,
        event.newPassword,
        emit,
      );
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    }
  }

  Future<void> _signOut(
    SettingsEventSignOut event,
    Emitter<SettingsState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _signOutUseCase.execute();
    emitInfo<SettingsBlocInfo>(emit, SettingsBlocInfo.userHasBeenSignedOut);
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

  void _setUserListener(String loggedUserId) {
    _userListener ??= _getUserUseCase.execute(userId: loggedUserId).listen(
          (User user) => add(
            SettingsEventUserUpdated(user: user),
          ),
        );
  }

  Future<void> _tryChangeLoggedUserPassword(
    String currentPassword,
    String newPassword,
    Emitter<SettingsState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _changeLoggedUserPasswordUseCase.execute(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    emitInfo<SettingsBlocInfo>(emit, SettingsBlocInfo.passwordHasBeenChanged);
  }

  Future<void> _tryDeleteLoggedUserAccount(
    String password,
    Emitter<SettingsState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _deleteLoggedUserUseCase.execute(password: password);
    emitInfo<SettingsBlocInfo>(
      emit,
      SettingsBlocInfo.userAccountHasBeenDeleted,
    );
  }

  void _manageAuthError(
    AuthError authError,
    Emitter<SettingsState> emit,
  ) {
    if (authError.code == AuthErrorCode.wrongPassword) {
      emitError(emit, SettingsBlocError.wrongPassword);
    } else if (authError.code == AuthErrorCode.userNotFound) {
      emitLoggedUserNotFoundStatus(emit);
    }
  }

  void _manageNetworkError(
    NetworkError networkError,
    Emitter<SettingsState> emit,
  ) {
    if (networkError.code == NetworkErrorCode.lossOfConnection) {
      emitLossOfInternetConnectionStatus(emit);
    }
  }
}
