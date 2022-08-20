part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  final BlocStatus status;
  final String email;
  final String password;

  const SignInState({
    required this.status,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        status,
        email,
        password,
      ];

  bool get isButtonDisabled => email.isEmpty || password.isEmpty;

  SignInState copyWith({
    BlocStatus? status,
    String? email,
    String? password,
  }) {
    return SignInState(
      status: status ?? const BlocStatusInProgress(),
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  SignInState copyWithInfo(SignInBlocInfo info) {
    return copyWith(
      status: BlocStatusComplete<SignInBlocInfo>(info: info),
    );
  }

  SignInState copyWithError(SignInBlocError error) {
    return copyWith(
      status: BlocStatusError<SignInBlocError>(error: error),
    );
  }
}

enum SignInBlocInfo {
  userHasBeenSignedIn,
}

enum SignInBlocError {
  invalidEmail,
  wrongPassword,
  userNotFound,
}
