import 'dart:async';

import 'package:app/config/errors.dart';
import 'package:app/domain/entities/user.dart';
import 'package:app/domain/use_cases/auth/change_logged_user_password_use_case.dart';
import 'package:app/domain/use_cases/auth/delete_logged_user_use_case.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_out_use_case.dart';
import 'package:app/domain/use_cases/user/get_user_use_case.dart';
import 'package:app/domain/use_cases/user/load_user_use_case.dart';
import 'package:app/domain/use_cases/user/update_theme_settings_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final LoadUserUseCase _loadUserUseCase;
  late final GetUserUseCase _getUserUseCase;
  late final UpdateThemeSettingsUseCase _updateThemeSettingsUseCase;
  late final ChangeLoggedUserPasswordUseCase _changeLoggedUserPasswordUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final DeleteLoggedUserUseCase _deleteLoggedUserUseCase;
  StreamSubscription<User>? _userListener;

  SettingsBloc({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required LoadUserUseCase loadUserUseCase,
    required GetUserUseCase getUserUseCase,
    required UpdateThemeSettingsUseCase updateThemeSettingsUseCase,
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
    _loadUserUseCase = loadUserUseCase;
    _getUserUseCase = getUserUseCase;
    _updateThemeSettingsUseCase = updateThemeSettingsUseCase;
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

  Future<void> _initialize(
    SettingsEventInitialize event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      emit(state.copyWith(
        status: const BlocStatusLoggedUserNotFound(),
      ));
    } else {
      await _loadUserUseCase.execute(userId: loggedUserId);
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
      await _updateThemeSettingsUseCase.execute(
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
      await _updateThemeSettingsUseCase.execute(
        userId: loggedUserId,
        isDarkModeCompatibilityWithSystemOn: event.isSwitched,
      );
    } catch (error) {
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
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _changeLoggedUserPasswordUseCase.execute(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    emit(state.copyWithInfo(
      SettingsBlocInfo.passwordHasBeenChanged,
    ));
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
