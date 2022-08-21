part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class SignUpEventAvatarChanged extends SignUpEvent {
  final Avatar avatar;

  SignUpEventAvatarChanged({required this.avatar});
}

class SignUpEventUsernameChanged extends SignUpEvent {
  final String username;

  SignUpEventUsernameChanged({required this.username});
}

class SignUpEventEmailChanged extends SignUpEvent {
  final String email;

  SignUpEventEmailChanged({required this.email});
}

class SignUpEventPasswordChanged extends SignUpEvent {
  final String password;

  SignUpEventPasswordChanged({required this.password});
}

class SignUpEventPasswordConfirmationChanged extends SignUpEvent {
  final String passwordConfirmation;

  SignUpEventPasswordConfirmationChanged({required this.passwordConfirmation});
}

class SignUpEventSubmit extends SignUpEvent {}
