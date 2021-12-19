import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
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
    if (username != null) {
      String? newUsername = await _dialogs.askForNewUsername(username);
      if (newUsername != null) {
        _profileBloc.add(
          ProfileActionsChangeUsername(newUsername: newUsername),
        );
      }
    }
  }

  onClickEmail(String currentEmail) async {
    await _dialogs.openEmailDialog(_profileBloc, currentEmail);
  }

  onClickPassword() async {
    await _dialogs.openPasswordDialog(_profileBloc);
  }
}
