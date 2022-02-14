import 'package:app/repositories/avatars/avatar_interface.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileActions extends Equatable {}

class ProfileActionsChangeAvatar extends ProfileActions {
  final AvatarInterface avatar;

  ProfileActionsChangeAvatar({required this.avatar});

  @override
  List<Object> get props => [avatar];
}

class ProfileActionsChangeUsername extends ProfileActions {
  final String newUsername;

  ProfileActionsChangeUsername({required this.newUsername});

  @override
  List<Object> get props => [newUsername];
}

class ProfileActionsChangeEmail extends ProfileActions {
  final String newEmail;
  final String password;

  ProfileActionsChangeEmail({required this.newEmail, required this.password});

  @override
  List<Object> get props => [newEmail, password];
}

class ProfileActionsChangePassword extends ProfileActions {
  final String currentPassword;
  final String newPassword;

  ProfileActionsChangePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}
