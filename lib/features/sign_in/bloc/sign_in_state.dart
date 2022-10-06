part of 'sign_in_bloc.dart';

class SignInState extends BlocState {
  final String email;
  final String password;

  const SignInState({
    required super.status,
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

  @override
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
}

enum SignInBlocInfo {
  userHasBeenSignedIn,
}

enum SignInBlocError {
  invalidEmail,
  wrongPassword,
  userNotFound,
}
