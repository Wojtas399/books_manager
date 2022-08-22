import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_error.dart';
import '../../../domain/use_cases/auth/sign_up_use_case.dart';
import '../../../models/avatar.dart';
import '../../../models/bloc_status.dart';
import '../../../validators/email_validator.dart';
import '../../../validators/password_validator.dart';
import '../../../validators/username_validator.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  late final UsernameValidator _usernameValidator;
  late final EmailValidator _emailValidator;
  late final PasswordValidator _passwordValidator;
  late final SignUpUseCase _signUpUseCase;

  SignUpBloc({
    required UsernameValidator usernameValidator,
    required EmailValidator emailValidator,
    required PasswordValidator passwordValidator,
    required SignUpUseCase signUpUseCase,
    BlocStatus status =  const BlocStatusInitial(),
    Avatar avatar = const BasicAvatar(type: BasicAvatarType.red),
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
    bool isUsernameValid = false,
    bool isEmailValid = false,
    bool isPasswordValid = false,
  }) : super(
          SignUpState(
            status: status,
            avatar: avatar,
            username: username,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
            isUsernameValid: isUsernameValid,
            isEmailValid: isEmailValid,
            isPasswordValid: isPasswordValid,
          ),
        ) {
    _usernameValidator = usernameValidator;
    _emailValidator = emailValidator;
    _passwordValidator = passwordValidator;
    _signUpUseCase = signUpUseCase;
    on<SignUpEventAvatarChanged>(_avatarChanged);
    on<SignUpEventUsernameChanged>(_usernameChanged);
    on<SignUpEventEmailChanged>(_emailChanged);
    on<SignUpEventPasswordChanged>(_passwordChanged);
    on<SignUpEventPasswordConfirmationChanged>(_passwordConfirmationChanged);
    on<SignUpEventSubmit>(_submit);
  }

  void _avatarChanged(
    SignUpEventAvatarChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      avatar: event.avatar,
    ));
  }

  void _usernameChanged(
    SignUpEventUsernameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      username: event.username,
      isUsernameValid: _usernameValidator.isValid(event.username),
    ));
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
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _signUpUseCase.execute(
        avatar: state.avatar,
        username: state.username,
        email: state.email,
        password: state.password,
      );
      emit(state.copyWithInfo(
        SignUpBlocInfo.userHasBeenSignedUp,
      ));
    } on AuthError catch (authError) {
      final SignUpBlocError? blocError = _convertAuthErrorToSignUpBlocError(
        authError,
      );
      if (blocError != null) {
        emit(state.copyWithError(
          blocError,
        ));
      }
    }
  }

  SignUpBlocError? _convertAuthErrorToSignUpBlocError(AuthError authError) {
    if (authError == AuthError.emailAlreadyInUse) {
      return SignUpBlocError.emailIsAlreadyTaken;
    }
    return null;
  }
}