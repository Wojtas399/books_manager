import 'dart:async';

import 'package:app/config/errors.dart';
import 'package:app/domain/use_cases/auth/sign_up_use_case.dart';
import 'package:app/models/bloc_state.dart';
import 'package:app/models/bloc_status.dart';
import 'package:app/models/error.dart';
import 'package:app/validators/email_validator.dart';
import 'package:app/validators/password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  late final EmailValidator _emailValidator;
  late final PasswordValidator _passwordValidator;
  late final SignUpUseCase _signUpUseCase;

  SignUpBloc({
    required EmailValidator emailValidator,
    required PasswordValidator passwordValidator,
    required SignUpUseCase signUpUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
    String passwordConfirmation = '',
    bool isEmailValid = false,
    bool isPasswordValid = false,
  }) : super(
          SignUpState(
            status: status,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
            isEmailValid: isEmailValid,
            isPasswordValid: isPasswordValid,
          ),
        ) {
    _emailValidator = emailValidator;
    _passwordValidator = passwordValidator;
    _signUpUseCase = signUpUseCase;
    on<SignUpEventEmailChanged>(_emailChanged);
    on<SignUpEventPasswordChanged>(_passwordChanged);
    on<SignUpEventPasswordConfirmationChanged>(_passwordConfirmationChanged);
    on<SignUpEventSubmit>(_submit);
  }

  void _emailChanged(
    SignUpEventEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
      isEmailValid: _emailValidator.isValid(event.email),
    ));
  }

  void _passwordChanged(
    SignUpEventPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
      isPasswordValid: _passwordValidator.isValid(event.password),
    ));
  }

  void _passwordConfirmationChanged(
    SignUpEventPasswordConfirmationChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      passwordConfirmation: event.passwordConfirmation,
    ));
  }

  Future<void> _submit(
    SignUpEventSubmit event,
    Emitter<SignUpState> emit,
  ) async {
    try {
      await _signUp(emit);
    } on AuthError catch (authError) {
      _manageAuthError(authError, emit);
    } on NetworkError catch (networkError) {
      _manageNetworkError(networkError, emit);
    } on TimeoutException catch (_) {
      _manageTimeoutException(emit);
    }
  }

  Future<void> _signUp(Emitter<SignUpState> emit) async {
    emit(state.copyWith(
      status: const BlocStatusLoading(),
    ));
    await _signUpUseCase
        .execute(email: state.email, password: state.password)
        .timeout(const Duration(seconds: 10));
    emit(state.copyWithInfo(
      SignUpBlocInfo.userHasBeenSignedUp,
    ));
  }

  void _manageAuthError(AuthError authError, Emitter<SignUpState> emit) {
    if (authError.code == AuthErrorCode.emailAlreadyInUse.name) {
      emit(state.copyWithError(
        SignUpBlocError.emailIsAlreadyTaken,
      ));
    }
  }

  void _manageNetworkError(
    NetworkError networkError,
    Emitter<SignUpState> emit,
  ) {
    if (networkError.code == NetworkErrorCode.lossOfConnection.name) {
      emit(state.copyWith(
        status: const BlocStatusLossOfInternetConnection(),
      ));
    }
  }

  void _manageTimeoutException(Emitter<SignUpState> emit) {
    emit(state.copyWith(
      status: const BlocStatusTimeoutException(),
    ));
  }
}
