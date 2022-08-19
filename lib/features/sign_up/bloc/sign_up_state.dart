part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final Avatar avatar;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool isUsernameValid;
  final bool isEmailValid;
  final bool isPasswordValid;

  const SignUpState({
    required this.avatar,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.isUsernameValid,
    required this.isEmailValid,
    required this.isPasswordValid,
  });

  @override
  List<Object> get props => [
        avatar,
        username,
        email,
        password,
        passwordConfirmation,
        isUsernameValid,
        isEmailValid,
        isPasswordValid,
      ];

  bool get isPasswordConfirmationValid => password == passwordConfirmation;

  bool get isButtonDisabled =>
      !isUsernameValid ||
      !isEmailValid ||
      !isPasswordValid ||
      password != passwordConfirmation;

  SignUpState copyWith({
    Avatar? avatar,
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
    bool? isUsernameValid,
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return SignUpState(
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }
}
