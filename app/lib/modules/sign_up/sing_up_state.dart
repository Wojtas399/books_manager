import 'package:app/core/form_submission_status.dart';
import 'package:app/common/enum/avatar_type.dart';

class SignUpState {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final AvatarType chosenAvatar;
  final String customAvatar;
  final FormSubmissionStatus formStatus;

  bool get isCorrectUsername => username.length >= 3;

  bool get isCorrectEmail => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  bool get isCorrectPassword => password.length >= 6;

  bool get isCorrectPasswordConfirmation => password == passwordConfirmation;

  bool get isDisabledButton =>
      !isCorrectUsername ||
      !isCorrectEmail ||
      !isCorrectPassword ||
      !isCorrectPasswordConfirmation;

  SignUpState({
    this.username = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.chosenAvatar = AvatarType.red,
    this.customAvatar = '',
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
    AvatarType? basicAvatar,
    String? customAvatar,
    FormSubmissionStatus? formStatus,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      chosenAvatar: basicAvatar ?? this.chosenAvatar,
      customAvatar: customAvatar ?? this.customAvatar,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
