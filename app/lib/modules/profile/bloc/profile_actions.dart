import 'package:equatable/equatable.dart';

abstract class ProfileActions {}

class ProfileActionsChangeAvatar extends Equatable implements ProfileActions {
  final String avatar;

  ProfileActionsChangeAvatar({required this.avatar});

  @override
  List<Object> get props => [avatar];
}

class ProfileActionsChangeUsername extends Equatable implements ProfileActions {
  final String newUsername;

  ProfileActionsChangeUsername({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}

class ProfileActionsChangeEmail extends Equatable implements ProfileActions {
  final String newEmail;
  final String password;

  ProfileActionsChangeEmail({required this.newEmail, required this.password});

  @override
  List<Object> get props => [newEmail, password];
}

class ProfileActionsChangePassword extends Equatable implements ProfileActions {
  final String currentPassword;
  final String newPassword;

  ProfileActionsChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}
