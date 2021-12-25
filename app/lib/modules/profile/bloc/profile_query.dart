import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_query.dart';

class ProfileQuery {
  late UserQuery _query;

  ProfileQuery({required UserQuery userQuery}) {
    _query = userQuery;
  }

  Stream<String> get username$ =>
      _query.username$.map((username) => username ?? '');

  Stream<String> get email$ => _query.email$.map((email) => email ?? '');

  Stream<AvatarInfo?> get avatarInfo$ => _query.avatarInfo$;
}
