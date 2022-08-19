part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final Avatar avatar;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  const SignUpState({
    required this.avatar,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [
        avatar,
        username,
        email,
        password,
        passwordConfirmation,
      ];

  bool get isButtonDisabled =>
      username.isEmpty ||
      email.isEmpty ||
      password.isEmpty ||
      passwordConfirmation.isEmpty;

  SignUpState copyWith({
    Avatar? avatar,
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return SignUpState(
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }
}
