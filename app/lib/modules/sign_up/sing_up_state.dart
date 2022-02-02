import 'package:app/models/operation_status.dart';
import 'package:app/common/enum/avatar_type.dart';

class SignUpState {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final AvatarType avatarType;
  final String customAvatarPath;
  final OperationStatus signUpStatus;

  bool get isCorrectUsername => username.length >= 3;

  bool get isCorrectEmail => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email);

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
    this.avatarType = AvatarType.red,
    this.customAvatarPath = '',
    this.signUpStatus = const InitialStatusOfOperation(),
  });

  SignUpState copyWith({
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
    AvatarType? avatarType,
    String? customAvatarPath,
    OperationStatus? signUpStatus,
  }) {
    return SignUpState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      avatarType: avatarType ?? this.avatarType,
      customAvatarPath: customAvatarPath ?? this.customAvatarPath,
      signUpStatus: signUpStatus ?? InitialStatusOfOperation(),
    );
  }
}
