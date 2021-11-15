import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';

class UserInfoController {
  late final UserBloc _userBloc;
  late final ProfileScreenDialogs _dialogs;

  UserInfoController({
    required UserBloc userBloc,
    required ProfileScreenDialogs profileScreenDialogs,
  }) {
    _userBloc = userBloc;
    _dialogs = profileScreenDialogs;
  }

  Stream<String?> get username$ => _userBloc.username$;

  Stream<String?> get email$ => _userBloc.email$;

  onClickUsername() async {
    String? username = await username$.first;
    if (username != null) {
      String? newUsername = await _dialogs.askForNewUsername(username);
      if (newUsername != null) {
        await _userBloc.updateUsername(newUsername);
      }
    }
  }

  onClickEmail(String currentEmail) async {
    await _dialogs.openEmailDialog(_userBloc, currentEmail);
  }

  onClickPassword() async {
    await _dialogs.openPasswordDialog(_userBloc);
  }
}
