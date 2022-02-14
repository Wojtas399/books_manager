import 'package:app/core/user/user_query.dart';
import 'package:app/repositories/avatars/avatar_interface.dart';
import 'package:rxdart/rxdart.dart';

class ProfileQuery {
  late UserQuery _query;

  ProfileQuery({required UserQuery userQuery}) {
    _query = userQuery;
  }

  Stream<String> get username$ =>
      _query.username$.map((username) => username ?? '');

  Stream<String> get email$ => _query.email$.map((email) => email ?? '');

  Stream<AvatarInterface> get avatar$ =>
      _query.avatar$.whereType<AvatarInterface>();
}
