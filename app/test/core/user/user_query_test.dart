import 'package:app/core/user/user_model.dart';
import 'package:app/core/user/user_query.dart';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  LoggedUser loggedUser = LoggedUser(
    username: 'username',
    email: 'email',
    avatar: StandardAvatarRed(),
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

  test('avatar', () async {
    AvatarInterface? avatar = await query.avatar$.first;

    expect(avatar, StandardAvatarRed());
  });
}
