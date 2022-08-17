part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  final String email;
  final String password;

  const SignInState({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        email,
        password,
      ];

  bool get isButtonDisabled => email.isEmpty || password.isEmpty;

  SignInState copyWith({
    String? email,
    String? password,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
