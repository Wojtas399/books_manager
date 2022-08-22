part of 'reset_password_bloc.dart';

class ResetPasswordState extends Equatable {
  final BlocStatus status;
  final String email;

  const ResetPasswordState({
    required this.status,
    required this.email,
  });

  @override
  List<Object> get props => [status, email];

  ResetPasswordState copyWith({
    BlocStatus? status,
    String? email,
  }) {
    return ResetPasswordState(
      status: status ?? const BlocStatusInProgress(),
      email: email ?? this.email,
    );
  }

  ResetPasswordState copyWithInfo(ResetPasswordBlocInfo info) {
    return copyWith(
      status: BlocStatusComplete<ResetPasswordBlocInfo>(info: info),
    );
  }

  ResetPasswordState copyWithError(ResetPasswordBlocError error) {
    return copyWith(
      status: BlocStatusError<ResetPasswordBlocError>(error: error),
    );
  }
}

enum ResetPasswordBlocInfo {
  emailHasBeenSent,
}

enum ResetPasswordBlocError {
  userNotFound,
}
