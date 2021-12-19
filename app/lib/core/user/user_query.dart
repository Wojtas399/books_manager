import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_model.dart';

class UserQuery {
  late Stream<LoggedUser?> _loggedUser$;

  UserQuery({required Stream<LoggedUser?> loggedUser$}) {
    _loggedUser$ = loggedUser$;
  }

  Stream<String?> get username$ => _loggedUser$.map((event) => event?.username);

  Stream<String?> get email$ => _loggedUser$.map((event) => event?.email);

  Stream<AvatarInfo?> get avatarInfo$ => _loggedUser$.map(
        (event) {
          LoggedUser? user = event;
          if (user != null) {
            return new AvatarInfo(
              avatarUrl: user.avatarUrl,
              avatarType: user.avatarType,
            );
          }
          return null;
        },
      );
}
