import 'package:app/core/user/user_model.dart';
import 'package:app/repositories/avatars/avatar_interface.dart';

class UserQuery {
  late Stream<LoggedUser?> _loggedUser$;

  UserQuery({required Stream<LoggedUser?> loggedUser$}) {
    _loggedUser$ = loggedUser$;
  }

  Stream<String?> get username$ => _loggedUser$.map((event) => event?.username);

  Stream<String?> get email$ => _loggedUser$.map((event) => event?.email);

  Stream<AvatarInterface?> get avatar$ =>
      _loggedUser$.map((event) => event?.avatar);
}
