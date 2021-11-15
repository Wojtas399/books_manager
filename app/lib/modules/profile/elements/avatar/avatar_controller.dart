import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';

enum AvatarActionSheetResult {
  fromGallery,
  basicAvatar,
}

class AvatarController {
  late final UserBloc _userBloc;
  late final AvatarBookService _avatarBookService;
  late final ImageService _imageService;
  late final ProfileScreenDialogs _dialogs;

  AvatarController({
    required UserBloc userBloc,
    required AvatarBookService avatarBookService,
    required ImageService imageService,
    required ProfileScreenDialogs profileScreenDialogs,
  }) {
    _userBloc = userBloc;
    _avatarBookService = avatarBookService;
    _imageService = imageService;
    _dialogs = profileScreenDialogs;
  }

  Stream<AvatarInfo?> get avatarInfo$ => _userBloc.avatarInfo$;

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
        await _userBloc.updateAvatar(avatarInfo.avatarUrl);
      }
    }
  }

  _onClickBasicAvatar() async {
    AvatarType? type = await _dialogs.askForBasicAvatar();
    if (type != null) {
      AvatarInfo avatarInfo = new AvatarInfo(avatarUrl: '', avatarType: type);
      bool? confirmation = await _dialogs.askForNewAvatarConfirmation(avatarInfo);
      if (confirmation != null && confirmation == true) {
        _userBloc.updateAvatar(
            _avatarBookService.getBookFileName(avatarInfo.avatarType));
      }
    }
  }
}
