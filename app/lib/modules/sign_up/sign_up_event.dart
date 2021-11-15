import 'package:app/common/enum/avatar_type.dart';

abstract class SignUpEvent {}

class SignUpUsernameChanged extends SignUpEvent {
  final String username;

  SignUpUsernameChanged({required this.username});
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged({required this.email});
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;

  SignUpPasswordChanged({required this.password});
}

class SignUpPasswordConfirmationChanged extends SignUpEvent {
  final String passwordConfirmation;

  SignUpPasswordConfirmationChanged({required this.passwordConfirmation});
}

class SignUpAvatarChanged extends SignUpEvent {
  final AvatarType type;

  SignUpAvatarChanged({required this.type});
}

class SignUpCustomAvatarChanged extends SignUpEvent {
  final String image;

  SignUpCustomAvatarChanged({required this.image});
}

class SignUpSubmitted extends SignUpEvent {
  final String username;
  final String email;
  final String password;
  final AvatarType chosenAvatar;
  final String customAvatar;

  SignUpSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.chosenAvatar,
    required this.customAvatar,
  });
}
