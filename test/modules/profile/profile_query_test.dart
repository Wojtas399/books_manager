import 'package:app/core/user/user_query.dart';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/modules/profile/bloc/profile_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  UserQuery userQuery = MockUserQuery();
  late ProfileQuery query;
  String fakeUsername = 'Jack Spark';
  String fakeEmail = 'jack@example.com';

  setUp(() {
    when(() => userQuery.username$).thenAnswer(
      (_) => Stream.value(fakeUsername),
    );
    when(() => userQuery.email$).thenAnswer(
      (_) => Stream.value(fakeEmail),
    );
    when(() => userQuery.avatar$).thenAnswer(
      (_) => Stream.value(StandardAvatarRed()),
    );

    query = ProfileQuery(userQuery: userQuery);
  });

  tearDown(() {
    reset(userQuery);
  });

  test('username', () async {
    String username = await query.username$.first;

    expect(username, fakeUsername);
  });

  test('email', () async {
    String email = await query.email$.first;

    expect(email, fakeEmail);
  });

  test('avatar', () async {
    AvatarInterface? avatar = await query.avatar$.first;

    expect(avatar, StandardAvatarRed());
  });
}
