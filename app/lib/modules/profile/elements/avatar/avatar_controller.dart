import 'package:app/core/services/image_service.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:app/interfaces/avatar_interface.dart';

enum AvatarChoiceOptions {
  fromGallery,
  basicAvatar,
}

class AvatarController {
  late final ProfileBloc _profileBloc;
  late final ImageService _imageService;
  late final ProfileScreenDialogs _dialogs;

  AvatarController({
    required ProfileBloc profileBloc,
    required ImageService imageService,
    required ProfileScreenDialogs profileScreenDialogs,
  }) {
    _profileBloc = profileBloc;
    _imageService = imageService;
    _dialogs = profileScreenDialogs;
  }

  selectAvatarChoiceOption() async {
    AvatarChoiceOptions? option = await _dialogs.askForAvatarChoiceOption();
    if (option != null) {
      switch (option) {
        case AvatarChoiceOptions.fromGallery:
          await _selectAvatarFromGallery();
          break;
        case AvatarChoiceOptions.basicAvatar:
          await _selectStandardAvatar();
          break;
      }
    }
  }

  _selectAvatarFromGallery() async {
    String? imgPath = await _imageService.getImageFromGallery();
    if (imgPath != null) {
      CustomAvatar avatar = new CustomAvatar(
        imgFilePathFromDevice: imgPath,
      );
      bool? confirmation = await _dialogs.askForNewAvatarConfirmation(avatar);
      if (confirmation == true) {
        _profileBloc.add(ProfileActionsChangeAvatar(avatar: avatar));
      }
    }
  }

  _selectStandardAvatar() async {
    StandardAvatarInterface? avatar = await _dialogs.askForStandardAvatar();
    if (avatar != null) {
      bool? confirmation = await _dialogs.askForNewAvatarConfirmation(avatar);
      if (confirmation == true) {
        _profileBloc.add(ProfileActionsChangeAvatar(avatar: avatar));
      }
    }
  }
}
