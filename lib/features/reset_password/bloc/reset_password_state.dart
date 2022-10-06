part of 'reset_password_bloc.dart';

class ResetPasswordState extends BlocState {
  final String email;

  const ResetPasswordState({
    required super.status,
    required this.email,
  });

  @override
  List<Object> get props => [status, email];

  @override
  ResetPasswordState copyWith({
    BlocStatus? status,
    String? email,
  }) {
    return ResetPasswordState(
      status: status ?? const BlocStatusInProgress(),
      email: email ?? this.email,
    );
  }

  bool get isButtonDisabled => email.isEmpty;
}

enum ResetPasswordBlocInfo {
  emailHasBeenSent,
}

enum ResetPasswordBlocError {
  invalidEmail,
  userNotFound,
}
