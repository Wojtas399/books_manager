import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/elements/user_info/email_dialog.dart';
import 'package:app/modules/profile/elements/user_info/password_dialog.dart';
import 'package:app/modules/profile/elements/user_info/user_info_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

class MockProfileScreenDialogs extends Mock implements ProfileScreenDialogs {}

void main() {
  ProfileBloc profileBloc = MockProfileBloc();
  ProfileScreenDialogs dialogs = MockProfileScreenDialogs();
  late UserInfoController controller;

  setUp(() {
    controller = UserInfoController(
      profileBloc: profileBloc,
      profileScreenDialogs: dialogs,
    );
  });

  tearDown(() {
    reset(profileBloc);
    reset(dialogs);
  });

  test('on click username', () async {
    String newUsername = 'new username';
    when(() => dialogs.askForNewUsername('username'))
        .thenAnswer((_) async => newUsername);

    await controller.onClickUsername('username');

    verify(
      () => profileBloc.add(
        ProfileActionsChangeUsername(newUsername: newUsername),
      ),
    ).called(1);
  });

  test('on click email', () async {
    EmailDialogResult result = EmailDialogResult(
      newEmail: 'newEmail',
      password: 'password',
    );
    when(() => dialogs.askForNewEmail(profileBloc, 'currentEmail'))
        .thenAnswer((_) async => result);

    await controller.onClickEmail('currentEmail');

    verify(
      () => profileBloc.add(ProfileActionsChangeEmail(
        newEmail: result.newEmail,
        password: result.password,
      )),
    ).called(1);
  });

  test('on click password', () async {
    PasswordDialogResult result = PasswordDialogResult(
      currentPassword: 'currentPassword',
      newPassword: 'newPassword',
    );
    when(() => dialogs.askForNewPassword(profileBloc))
        .thenAnswer((_) async => result);

    await controller.onClickPassword();

    verify(
      () => profileBloc.add(ProfileActionsChangePassword(
        currentPassword: result.currentPassword,
        newPassword: result.newPassword,
      )),
    ).called(1);
  });
}
