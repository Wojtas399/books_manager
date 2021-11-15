import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/repositories/auth/auth_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  AuthInterface authInterface = MockAuthInterface();
  late UserBloc userBloc;

  setUp(() => userBloc = new UserBloc(authInterface: authInterface));

  tearDown(() => reset(authInterface));

  group('default state', () {
    group('username', () {
      test('Should be null', () async {
        String? username = await userBloc.username$.first;
        expect(username, null);
      });
    });

    group('email', () {
      test('Should be null', () async {
        String? email = await userBloc.email$.first;
        expect(email, null);
      });
    });

    group('avatarInfo', () {
      test('Should be null', () async {
        AvatarInfo? avatarInfo = await userBloc.avatarInfo$.first;
        expect(avatarInfo, null);
      });
    });
  });

  group('updated state', () {
    setUp(() {
      userBloc.setUserData(
        username: 'Jan Nowak',
        email: 'jannowak@example.com',
        avatarUrl: 'http://avatar/img.png',
        avatarType: AvatarType.custom,
      );
    });

    group('username', () {
      test('Should be the username of logged user', () async {
        String? username = await userBloc.username$.first;
        expect(username, 'Jan Nowak');
      });
    });

    group('email', () {
      test('Should be the email of logged user', () async {
        String? email = await userBloc.email$.first;
        expect(email, 'jannowak@example.com');
      });
    });

    group('avatarInfo', () {
      test('Should be the avatar info of logged user', () async {
        AvatarInfo? avatarInfo = await userBloc.avatarInfo$.first;
        expect(avatarInfo?.avatarUrl, 'http://avatar/img.png');
        expect(avatarInfo?.avatarType, AvatarType.custom);
      });
    });
  });

  group('updateAvatar', () {
    setUp(() async {
      await userBloc.updateAvatar('avatar/new.jpg');
    });

    test('Should call change avatar method from auth repo', () {
      verify(() => authInterface.changeAvatar(avatar: 'avatar/new.jpg'))
          .called(1);
    });
  });

  group('updateUsername', () {
    setUp(() async {
      await userBloc.updateUsername('username');
    });

    test('Should call change username method from auth repo', () {
      verify(() => authInterface.changeUsername(newUsername: 'username'))
          .called(1);
    });
  });

  group('updateEmail', () {
    setUp(() async {
      await userBloc.updateEmail('jan@example.com', 'password');
    });

    test('Should call change email method from auth repo', () {
      verify(() => authInterface.changeEmail(
            newEmail: 'jan@example.com',
            password: 'password',
          )).called(1);
    });
  });

  group('updatePassword', () {
    setUp(() async {
      await userBloc.updatePassword('currentPassword', 'newPassword');
    });

    test('Should call change password method from auth repo', () {
      verify(() => authInterface.changePassword(
            currentPassword: 'currentPassword',
            newPassword: 'newPassword',
          )).called(1);
    });
  });

  group('signOut', () {
    setUp(() async {
      await userBloc.signOut();
    });

    test('Should call log out method from auth repo', () {
      verify(() => authInterface.logOut()).called(1);
    });
  });
}
