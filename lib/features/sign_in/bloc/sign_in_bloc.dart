import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    String email = '',
    String password = '',
  }) : super(
          SignInState(
            email: email,
            password: password,
          ),
        ) {
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
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
}
