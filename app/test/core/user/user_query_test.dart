import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_model.dart';
import 'package:app/core/user/user_query.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LoggedUser loggedUser = LoggedUser(
    username: 'username',
    email: 'email',
    avatarType: AvatarType.custom,
    avatarUrl: 'avatarUrl',
  );
  late UserQuery query;

  setUp(() {
    query = UserQuery(loggedUser$: Stream.value(loggedUser));
  });

  test('username', () async {
    String? username = await query.username$.first;

    expect(username, loggedUser.username);
  });

  test('email', () async {
    String? email = await query.email$.first;

    expect(email, loggedUser.email);
  });

  test('avatar info', () async {
    AvatarInfo? avatarInfo = await query.avatarInfo$.first;

    expect(
      avatarInfo,
      AvatarInfo(
        avatarUrl: loggedUser.avatarUrl,
        avatarType: loggedUser.avatarType,
      ),
    );
  });
}
