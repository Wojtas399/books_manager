import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/auth_state.dart';
import '../../../domain/use_cases/auth/get_auth_state_use_case.dart';
import '../../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../../models/bloc_status.dart';
import '../../../models/error.dart';

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
    return authState is AuthStateSignedIn;
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
    if (authError.code == AuthErrorCode.invalidEmail.name) {
      emit(state.copyWithError(
        SignInBlocError.invalidEmail,
      ));
    } else if (authError.code == AuthErrorCode.wrongPassword.name) {
      emit(state.copyWithError(
        SignInBlocError.wrongPassword,
      ));
    } else if (authError.code == AuthErrorCode.userNotFound.name) {
      emit(state.copyWithError(
        SignInBlocError.userNotFound,
      ));
    }
  }
}
