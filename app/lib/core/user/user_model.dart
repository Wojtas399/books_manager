import 'package:app/common/enum/avatar_type.dart';

class LoggedUser {
  String username;
  String email;
  AvatarType avatarType;
  String avatarUrl;

  LoggedUser({
    required this.username,
    required this.email,
    required this.avatarType,
    required this.avatarUrl,
  });
}
