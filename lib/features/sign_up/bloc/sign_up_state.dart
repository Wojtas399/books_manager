part of 'sign_up_bloc.dart';

class SignUpState extends BlocState {
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool isEmailValid;
  final bool isPasswordValid;

  const SignUpState({
    required super.status,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.isEmailValid,
    required this.isPasswordValid,
  });

  @override
  List<Object> get props => [
        status,
        email,
        password,
        passwordConfirmation,
        isEmailValid,
        isPasswordValid,
      ];

  bool get isPasswordConfirmationValid => password == passwordConfirmation;

  bool get isButtonDisabled =>
      !isEmailValid || !isPasswordValid || !isPasswordConfirmationValid;

  SignUpState copyWith({
    BlocStatus? status,
    String? email,
    String? password,
    String? passwordConfirmation,
    bool? isEmailValid,
    bool? isPasswordValid,
  }) {
    return SignUpState(
      status: status ?? const BlocStatusInProgress(),
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    );
  }

  SignUpState copyWithInfo(SignUpBlocInfo info) {
    return copyWith(
      status: BlocStatusComplete<SignUpBlocInfo>(info: info),
    );
  }

  SignUpState copyWithError(SignUpBlocError error) {
    return copyWith(
      status: BlocStatusError<SignUpBlocError>(error: error),
    );
  }
}

enum SignUpBlocInfo {
  userHasBeenSignedUp,
}

enum SignUpBlocError {
  emailIsAlreadyTaken,
}
