import 'package:app/common/enum/avatar_type.dart';

abstract class SignUpAction {}

class SignUpUsernameChanged extends SignUpAction {
  final String username;

  SignUpUsernameChanged({required this.username});
}

class SignUpEmailChanged extends SignUpAction {
  final String email;

  SignUpEmailChanged({required this.email});
}

class SignUpPasswordChanged extends SignUpAction {
  final String password;

  SignUpPasswordChanged({required this.password});
}

class SignUpPasswordConfirmationChanged extends SignUpAction {
  final String passwordConfirmation;

  SignUpPasswordConfirmationChanged({required this.passwordConfirmation});
}

class SignUpAvatarTypeChanged extends SignUpAction {
  final AvatarType avatarType;

  SignUpAvatarTypeChanged({required this.avatarType});
}

class SignUpCustomAvatarPathChanged extends SignUpAction {
  final String imagePath;

  SignUpCustomAvatarPathChanged({required this.imagePath});
}

class SignUpSubmitted extends SignUpAction {
  final String username;
  final String email;
  final String password;
  final AvatarType avatarType;
  final String customAvatarPath;

  SignUpSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.avatarType,
    required this.customAvatarPath,
  });
}
