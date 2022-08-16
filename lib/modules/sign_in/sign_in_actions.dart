abstract class SignInAction {}

class SignInEmailChanged extends SignInAction {
  final String email;

  SignInEmailChanged({required this.email});
}

class SignInPasswordChanged extends SignInAction {
  final String password;

  SignInPasswordChanged({required this.password});
}

class SignInSubmitted extends SignInAction {
  final String email;
  final String password;

  SignInSubmitted({required this.email, required this.password});
}
