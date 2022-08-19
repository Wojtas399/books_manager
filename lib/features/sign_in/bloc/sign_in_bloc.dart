import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_error.dart';
import '../../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../../models/bloc_status.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  late final SignInUseCase _signInUseCase;

  SignInBloc({
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
    _signInUseCase = signInUseCase;
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
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
      emit(state.copyWith(
        status: const BlocStatusLoading(),
      ));
      await _signInUseCase.execute(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWithInfo(
        SignInBlocInfo.userHasBeenSignedIn,
      ));
    } on AuthError catch (authError) {
      SignInBlocError? signInBlocError = _convertAuthErrorToSignInBlocError(
        authError,
      );
      if (signInBlocError != null) {
        emit(state.copyWithError(
          signInBlocError,
        ));
      }
    }
  }

  SignInBlocError? _convertAuthErrorToSignInBlocError(AuthError authError) {
    if (authError == AuthError.invalidEmail) {
      return SignInBlocError.invalidEmail;
    } else if (authError == AuthError.invalidPassword) {
      return SignInBlocError.invalidPassword;
    } else if (authError == AuthError.userNotFound) {
      return SignInBlocError.userNotFound;
    }
    return null;
  }
}
