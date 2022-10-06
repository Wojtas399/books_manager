import 'dart:async';

import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/auth/load_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/auth/sign_in_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/custom_bloc.dart';
import 'package:app/models/error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends CustomBloc<SignInEvent, SignInState> {
  late final LoadLoggedUserIdUseCase _loadLoggedUserIdUseCase;
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final SignInUseCase _signInUseCase;

  SignInBloc({
    required LoadLoggedUserIdUseCase loadLoggedUserIdUseCase,
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required SignInUseCase signInUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  }) : super(
          SignInState(
            status: status,
            email: email,
            password: password,
          ),
        ) {
    _loadLoggedUserIdUseCase = loadLoggedUserIdUseCase;
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _signInUseCase = signInUseCase;
    on<SignInEventInitialize>(_initialize);
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
    on<SignInEventCleanForm>(_cleanForm);
  }

  Future<void> _initialize(
    SignInEventInitialize event,
    Emitter<SignInState> emit,
  ) async {
    if (await _isUserSignedIn()) {
      emitInfo(emit, SignInBlocInfo.userHasBeenSignedIn);
    }
  }

  void _emailChanged(
    SignInEventEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _passwordChanged(
    SignInEventPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
    ));
  }

  Future<void> _submit(
    SignInEventSubmit event,
    Emitter<SignInState> emit,
  ) async {
    try {
      await _tryToSignIn(emit);
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    } on NetworkError catch (networkError) {
      _manageNetworkError(networkError, emit);
    } on TimeoutException catch (_) {
      emitTimeoutExceptionStatus(emit);
    }
  }

  void _cleanForm(
    SignInEventCleanForm event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      email: '',
      password: '',
    ));
  }

  Future<bool> _isUserSignedIn() async {
    await _loadLoggedUserIdUseCase.execute();
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    return loggedUserId != null;
  }

  Future<void> _tryToSignIn(Emitter<SignInState> emit) async {
    emitLoadingStatus(emit);
    await _signInUseCase
        .execute(email: state.email, password: state.password)
        .timeout(const Duration(seconds: 10));
    emitInfo<SignInBlocInfo>(emit, SignInBlocInfo.userHasBeenSignedIn);
  }

  void _manageAuthError(AuthError authError, Emitter<SignInState> emit) {
    if (authError.code == AuthErrorCode.invalidEmail) {
      emitError<SignInBlocError>(emit, SignInBlocError.invalidEmail);
    } else if (authError.code == AuthErrorCode.wrongPassword) {
      emitError<SignInBlocError>(emit, SignInBlocError.wrongPassword);
    } else if (authError.code == AuthErrorCode.userNotFound) {
      emitError<SignInBlocError>(emit, SignInBlocError.userNotFound);
    }
  }

  void _manageNetworkError(
    NetworkError networkError,
    Emitter<SignInState> emit,
  ) {
    if (networkError.code == NetworkErrorCode.lossOfConnection) {
      emitLossOfInternetConnectionStatus(emit);
    }
  }
}
