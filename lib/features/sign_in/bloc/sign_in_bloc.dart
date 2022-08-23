import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_error.dart';
import '../../../domain/entities/auth_state.dart';
import '../../../domain/entities/network_error.dart';
import '../../../domain/use_cases/auth/get_auth_state_use_case.dart';
import '../../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../../models/bloc_status.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  late final GetAuthStateUseCase _getAuthStateUseCase;
  late final SignInUseCase _signInUseCase;

  SignInBloc({
    required GetAuthStateUseCase getAuthStateUseCase,
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
    _getAuthStateUseCase = getAuthStateUseCase;
    _signInUseCase = signInUseCase;
    on<SignInEventInitialize>(_initialize);
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
  }

  Future<void> _initialize(
    SignInEventInitialize event,
    Emitter<SignInState> emit,
  ) async {
    if (await _isUserSignedIn()) {
      emit(state.copyWithInfo(
        SignInBlocInfo.userHasBeenSignedIn,
      ));
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
      await _signIn(emit);
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    } on NetworkError catch (_) {
      emit(state.copyWithError(
        SignInBlocError.noInternetConnection,
      ));
    } on TimeoutException catch (_) {
      emit(state.copyWithError(
        SignInBlocError.timeoutException,
      ));
    }
  }

  Future<bool> _isUserSignedIn() async {
    final AuthState authState = await _getAuthStateUseCase.execute().first;
    return authState == AuthState.signedIn;
  }

  Future<void> _signIn(Emitter<SignInState> emit) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _signInUseCase
        .execute(email: state.email, password: state.password)
        .timeout(const Duration(seconds: 10));
    emit(state.copyWithInfo(
      SignInBlocInfo.userHasBeenSignedIn,
    ));
  }

  void _manageAuthError(AuthError authError, Emitter<SignInState> emit) {
    SignInBlocError? blocError = _convertAuthErrorToSignInBlocError(
      authError,
    );
    if (blocError != null) {
      emit(state.copyWithError(
        blocError,
      ));
    }
  }

  SignInBlocError? _convertAuthErrorToSignInBlocError(AuthError authError) {
    if (authError == AuthError.invalidEmail) {
      return SignInBlocError.invalidEmail;
    } else if (authError == AuthError.wrongPassword) {
      return SignInBlocError.wrongPassword;
    } else if (authError == AuthError.userNotFound) {
      return SignInBlocError.userNotFound;
    }
    return null;
  }
}
