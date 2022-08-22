part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent {}

class ResetPasswordEventEmailChanged extends ResetPasswordEvent {
  final String email;

  ResetPasswordEventEmailChanged({required this.email});
}

class ResetPasswordEventSubmit extends ResetPasswordEvent {}
