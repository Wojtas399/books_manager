import 'package:app/models/operation_status.dart';

class SignInState {
  final String email;
  final String password;
  final OperationStatus signInStatus;

  bool get isDisabledButton => email.length == 0 || password.length == 0;

  SignInState({
    this.email = '',
    this.password = '',
    this.signInStatus = const InitialStatusOfOperation(),
  });

  SignInState copyWith({
    String? email,
    String? password,
    OperationStatus? signInStatus,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      signInStatus: signInStatus ?? InitialStatusOfOperation(),
    );
  }
}
