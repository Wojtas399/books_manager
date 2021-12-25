import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_query.dart';
import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../global_mocks.dart';

void main() {
  UserQuery userQuery = MockUserQuery();
  UserBloc userBloc = MockUserBloc();
  late ProfileBloc bloc;

  setUp(() {
    bloc = ProfileBloc(userQuery: userQuery, userBloc: userBloc);
  });

  tearDown(() {
    reset(userQuery);
    reset(userBloc);
  });

  blocTest(
    'change avatar',
    build: () => bloc,
    act: (ProfileBloc profileBloc) {
      profileBloc.add(ProfileActionsChangeAvatar(
        avatar: 'new/avatar/file',
      ));
    },
    verify: (_) {
      verify(
        () => userBloc.updateAvatar('new/avatar/file'),
      ).called(1);
    },
  );

  blocTest(
    'change username',
    build: () => bloc,
    act: (ProfileBloc profileBloc) {
      profileBloc.add(ProfileActionsChangeUsername(newUsername: 'Michael Act'));
    },
    verify: (_) {
      verify(
        () => userBloc.updateUsername('Michael Act'),
      ).called(1);
    },
  );

  blocTest(
    'change email',
    build: () => bloc,
    act: (ProfileBloc profileBloc) {
      profileBloc.add(ProfileActionsChangeEmail(
        newEmail: 'michael@example.com',
        password: 'Michael123',
      ));
    },
    verify: (_) {
      verify(
        () => userBloc.updateEmail('michael@example.com', 'Michael123'),
      ).called(1);
    },
  );

  blocTest(
    'change password',
    build: () => bloc,
    act: (ProfileBloc profileBloc) {
      profileBloc.add(ProfileActionsChangePassword(
        currentPassword: 'Michael123',
        newPassword: 'michael321',
      ));
    },
    verify: (_) {
      verify(
        () => userBloc.updatePassword('Michael123', 'michael321'),
      ).called(1);
    },
  );
}
