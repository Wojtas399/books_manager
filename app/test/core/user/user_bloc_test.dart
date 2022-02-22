import 'package:app/core/user/user_bloc.dart';
import 'package:app/core/user/user_model.dart';
import 'package:app/interfaces/user_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserInterface extends Mock implements UserInterface {}

void main() {
  UserInterface userInterface = MockUserInterface();
  late UserBloc bloc;

  setUp(() {
    bloc = new UserBloc(userInterface: userInterface);
  });

  tearDown(() {
    reset(userInterface);
  });

  test('set user data', () async {
    bloc.setUserData(
      username: 'username',
      email: 'email@example.com',
      avatar: StandardAvatarRed(),
    );

    LoggedUser? loggedUser = await bloc.loggedUser$.first;
    expect(loggedUser?.username, 'username');
    expect(loggedUser?.email, 'email@example.com');
    expect(loggedUser?.avatar, isA<StandardAvatarRed>());
  });

  test('update avatar', () {
    bloc.updateAvatar(StandardAvatarBlue());

    verify(() => userInterface.changeAvatar(avatar: StandardAvatarBlue()))
        .called(1);
  });

  test('update username', () {
    bloc.updateUsername('new username');

    verify(
      () => userInterface.changeUsername(newUsername: 'new username'),
    ).called(1);
  });

  test('update email', () {
    bloc.updateEmail('newEmail@example.com', 'password');

    verify(
      () => userInterface.changeEmail(
        newEmail: 'newEmail@example.com',
        password: 'password',
      ),
    ).called(1);
  });

  test('update password', () {
    bloc.updatePassword('currentPassword', 'newPassword');

    verify(
      () => userInterface.changePassword(
        currentPassword: 'currentPassword',
        newPassword: 'newPassword',
      ),
    ).called(1);
  });
}
