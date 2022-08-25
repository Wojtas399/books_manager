part of 'sign_in_bloc.dart';

abstract class SignInEvent {
  const SignInEvent();
}

class SignInEventInitialize extends SignInEvent {
  const SignInEventInitialize();
}

class SignInEventEmailChanged extends SignInEvent {
  final String email;

  const SignInEventEmailChanged({required this.email});
}

class SignInEventPasswordChanged extends SignInEvent {
  final String password;

  const SignInEventPasswordChanged({required this.password});
}

class SignInEventSubmit extends SignInEvent {
  const SignInEventSubmit();
}

class SignInEventCleanForm extends SignInEvent {
  const SignInEventCleanForm();
}
