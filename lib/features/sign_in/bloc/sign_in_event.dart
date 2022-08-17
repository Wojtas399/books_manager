part of 'sign_in_bloc.dart';

abstract class SignInEvent {}

class SignInEventEmailChanged extends SignInEvent {
  final String email;

  SignInEventEmailChanged({required this.email});
}

class SignInEventPasswordChanged extends SignInEvent {
  final String password;

  SignInEventPasswordChanged({required this.password});
}

class SignInEventSubmit extends SignInEvent {}
