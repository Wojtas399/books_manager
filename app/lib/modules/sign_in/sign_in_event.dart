abstract class SignInEvent {}

class SignInEmailChanged extends SignInEvent {
  final String email;

  SignInEmailChanged({required this.email});
}

class SignInPasswordChanged extends SignInEvent {
  final String password;

  SignInPasswordChanged({required this.password});
}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;

  SignInSubmitted({required this.email, required this.password});
}
