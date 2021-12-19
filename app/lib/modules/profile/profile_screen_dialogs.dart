import 'package:app/common/enum/avatar_type.dart';
import 'package:app/common/ui/action_sheet.dart';
import 'package:app/common/ui/dialogs.dart';
import 'package:app/core/services/validation_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'elements/avatar/avatar_action_sheet.dart';
import 'elements/avatar/avatar_controller.dart';
import 'elements/avatar/chose_basic_avatar_dialog.dart';
import 'elements/avatar/new_avatar_preview.dart';
import 'elements/user_info/email_dialog.dart';
import 'elements/user_info/password_dialog.dart';

class ProfileScreenDialogs {
  Future<AvatarActionSheetResult?> askForAvatarOperation() async {
    return await ActionSheet.showActionSheet(AvatarActionSheet());
  }

  Future<bool?> askForNewAvatarConfirmation(
    AvatarInfo avatarInfo,
  ) async {
    return await Dialogs.showCustomDialog(
      child: NewAvatarPreview(avatarInfo: avatarInfo),
    );
  }

  Future<AvatarType?> askForBasicAvatar() async {
    return await Dialogs.showCustomDialog(child: ChoseBasicAvatarDialog());
  }

  Future<String?> askForNewUsername(
    String currentUsername,
  ) async {
    return await Dialogs.showSingleInputDialog(
      title: 'Zmień nazwę użytkownika',
      label: 'Nowa nazwa użytkownika',
      controller: TextEditingController(text: currentUsername),
      validator: (val) => _validateUsername(val ?? ''),
    );
  }

  openEmailDialog(
    ProfileBloc profileBloc,
    String currentEmail,
  ) async {
    await Dialogs.showCustomDialog(
      child: Provider<ProfileBloc>.value(
        value: profileBloc,
        child: EmailDialog(
          currentEmail: currentEmail,
        ),
      ),
    );
  }

  openPasswordDialog(
    ProfileBloc profileBloc,
  ) async {
    await Dialogs.showCustomDialog(
      child: Provider<ProfileBloc>.value(
        value: profileBloc,
        child: PasswordDialog(),
      ),
    );
  }

  String? _validateUsername(String username) {
    final ValidationService validationService = ValidationService();
    if (username == '') {
      return 'To pole jest wymagane';
    } else {
      return validationService.checkValue(ValidationKey.username, username)
          ? null
          : 'Nazwa musi zawierać co najmniej 3 znaki';
    }
  }
}
