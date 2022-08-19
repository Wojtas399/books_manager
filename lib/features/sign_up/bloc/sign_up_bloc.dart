import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/avatar.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    Avatar avatar = const BasicAvatar(type: BasicAvatarType.red),
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) : super(
          SignUpState(
            avatar: avatar,
            username: username,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        ) {
    on<SignUpEventAvatarChanged>(_avatarChanged);
    on<SignUpEventUsernameChanged>(_usernameChanged);
    on<SignUpEventEmailChanged>(_emailChanged);
    on<SignUpEventPasswordChanged>(_passwordChanged);
    on<SignUpEventPasswordConfirmationChanged>(_passwordConfirmationChanged);
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
    ));
  }

  void _emailChanged(
    SignUpEventEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      email: event.email,
    ));
  }

  void _passwordChanged(
    SignUpEventPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      password: event.password,
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
}
