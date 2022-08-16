import 'package:app/interfaces/avatar_interface.dart';

class LoggedUser {
  String username;
  String email;
  AvatarInterface avatar;

  LoggedUser({
    required this.username,
    required this.email,
    required this.avatar,
  });
}
