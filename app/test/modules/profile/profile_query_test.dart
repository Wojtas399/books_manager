import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_query.dart';
import 'package:app/modules/profile/bloc/profile_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  UserQuery userQuery = MockUserQuery();
  late ProfileQuery query;
  String fakeUsername = 'Jack Spark';
  String fakeEmail = 'jack@example.com';
  AvatarInfo fakeAvatarInfo = AvatarInfo(
    avatarUrl: 'avatar/url',
    avatarType: AvatarType.custom,
  );

  setUp(() {
    when(() => userQuery.username$).thenAnswer(
      (_) => Stream.value(fakeUsername),
    );
    when(() => userQuery.email$).thenAnswer(
      (_) => Stream.value(fakeEmail),
    );
    when(() => userQuery.avatarInfo$).thenAnswer(
      (_) => Stream.value(fakeAvatarInfo),
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

  test('avatar info', () async {
    AvatarInfo? avatarInfo = await query.avatarInfo$.first;

    expect(avatarInfo, fakeAvatarInfo);
  });
}
