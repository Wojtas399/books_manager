import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/elements/user_info/email_dialog.dart';
import 'package:app/modules/profile/elements/user_info/password_dialog.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';

class UserInfoController {
  late final ProfileBloc _profileBloc;
  late final ProfileScreenDialogs _dialogs;

  UserInfoController({
    required ProfileBloc profileBloc,
    required ProfileScreenDialogs profileScreenDialogs,
  }) {
    _profileBloc = profileBloc;
    _dialogs = profileScreenDialogs;
  }

  onClickUsername(String? username) async {
    String? newUsername = await _dialogs.askForNewUsername(username ?? '');
    if (newUsername != null) {
      _profileBloc.add(
        ProfileActionsChangeUsername(newUsername: newUsername),
      );
    }
  }

  onClickEmail(String currentEmail) async {
    EmailDialogResult? result = await _dialogs.askForNewEmail(
      _profileBloc,
      currentEmail,
    );
    if (result != null) {
      _profileBloc.add(ProfileActionsChangeEmail(
        newEmail: result.newEmail,
        password: result.password,
      ));
    }
  }

  onClickPassword() async {
    PasswordDialogResult? result =
        await _dialogs.askForNewPassword(_profileBloc);
    if (result != null) {
      _profileBloc.add(ProfileActionsChangePassword(
        currentPassword: result.currentPassword,
        newPassword: result.newPassword,
      ));
    }
  }
}
