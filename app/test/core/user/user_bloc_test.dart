import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_model.dart';
import 'package:app/repositories/auth_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthInterface extends Mock implements AuthInterface {}

void main() {
  AuthInterface authInterface = MockAuthInterface();
  late UserBloc bloc;

  setUp(() {
    bloc = new UserBloc(authInterface: authInterface);
  });

  tearDown(() {
    reset(authInterface);
  });

  test('set user data', () async {
    bloc.setUserData(
      username: 'username',
      email: 'email@example.com',
      avatarUrl: 'url',
      avatarType: AvatarType.blue,
    );

    LoggedUser? loggedUser = await bloc.loggedUser$.first;
    expect(loggedUser?.username, 'username');
    expect(loggedUser?.email, 'email@example.com');
    expect(loggedUser?.avatarUrl, 'url');
    expect(loggedUser?.avatarType, AvatarType.blue);
  });

  test('update avatar', () {
    bloc.updateAvatar('new avatar');

    verify(() => authInterface.changeAvatar(avatar: 'new avatar')).called(1);
  });

  test('update username', () {
    bloc.updateUsername('new username');

    verify(
      () => authInterface.changeUsername(newUsername: 'new username'),
    ).called(1);
  });

  test('update email', () {
    bloc.updateEmail('newEmail@example.com', 'password');

    verify(
      () => authInterface.changeEmail(
        newEmail: 'newEmail@example.com',
        password: 'password',
      ),
    ).called(1);
  });

  test('update password', () {
    bloc.updatePassword('currentPassword', 'newPassword');

    verify(
      () => authInterface.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      ),
    ).called(1);
  });

  test('sign out', () {
    bloc.signOut();

    verify(() => authInterface.logOut()).called(1);
  });
}
