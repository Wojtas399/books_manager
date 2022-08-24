part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

class ResetPasswordEventEmailChanged extends ResetPasswordEvent {
  final String email;

  const ResetPasswordEventEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class ResetPasswordEventSubmit extends ResetPasswordEvent {
  const ResetPasswordEventSubmit();
}
