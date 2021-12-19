import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';

enum AvatarActionSheetResult {
  fromGallery,
  basicAvatar,
}

class AvatarController {
  late final ProfileBloc _profileBloc;
  late final AvatarBookService _avatarBookService;
  late final ImageService _imageService;
  late final ProfileScreenDialogs _dialogs;

  AvatarController({
    required ProfileBloc profileBloc,
    required AvatarBookService avatarBookService,
    required ImageService imageService,
    required ProfileScreenDialogs profileScreenDialogs,
  }) {
    _profileBloc = profileBloc;
    _avatarBookService = avatarBookService;
    _imageService = imageService;
    _dialogs = profileScreenDialogs;
  }

  openAvatarActionSheet() async {
    AvatarActionSheetResult? result = await _dialogs.askForAvatarOperation();
    if (result != null) {
      switch (result) {
        case AvatarActionSheetResult.fromGallery:
          await _onClickFromGallery();
          break;
        case AvatarActionSheetResult.basicAvatar:
          await _onClickBasicAvatar();
          break;
      }
    }
  }

  _onClickFromGallery() async {
    String? imgPath = await _imageService.getImageFromGallery();
    if (imgPath != null) {
      AvatarInfo avatarInfo = new AvatarInfo(
        avatarUrl: imgPath,
        avatarType: AvatarType.custom,
      );
      bool? confirmation =
          await _dialogs.askForNewAvatarConfirmation(avatarInfo);
      if (confirmation == true) {
        _profileBloc.add(ProfileActionsChangeAvatar(
          avatar: avatarInfo.avatarUrl,
        ));
      }
    }
  }

  _onClickBasicAvatar() async {
    AvatarType? type = await _dialogs.askForBasicAvatar();
    if (type != null) {
      AvatarInfo avatarInfo = new AvatarInfo(avatarUrl: '', avatarType: type);
      bool? confirmation =
          await _dialogs.askForNewAvatarConfirmation(avatarInfo);
      if (confirmation == true) {
        _profileBloc.add(ProfileActionsChangeAvatar(
          avatar: _avatarBookService.getBookFileName(avatarInfo.avatarType),
        ));
      }
    }
  }
}
