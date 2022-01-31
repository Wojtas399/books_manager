import 'package:app/core/form_submission_status.dart';

class SignInState {
  final String email;
  final String password;
  final FormSubmissionStatus formStatus;

  bool get isDisabledButton => email.length == 0 || password.length == 0;

  SignInState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignInState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
