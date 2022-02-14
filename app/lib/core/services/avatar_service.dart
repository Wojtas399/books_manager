import 'package:app/injection/backend_avatar_provider.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/interfaces/avatars/avatar_interface.dart';
import 'package:app/interfaces/avatars/sign_up_backend_avatar_interface.dart';

class AvatarService {
  static SignUpBackendAvatarInterface getBackendAvatar(
    AvatarInterface avatar,
  ) {
    if (avatar is StandardAvatarRed) {
      return BackendAvatarProvider.getStandardAvatarRed();
    } else if (avatar is StandardAvatarGreen) {
      return BackendAvatarProvider.getStandardAvatarGreen();
    } else if (avatar is StandardAvatarBlue) {
      return BackendAvatarProvider.getStandardAvatarBlue();
    } else if (avatar is CustomAvatar) {
      String? imgFilePathFromDevice = avatar.imgFilePathFromDevice;
      if (imgFilePathFromDevice != null) {
        return BackendAvatarProvider.getCustomAvatar(
          imgFilePathFromDevice: imgFilePathFromDevice,
        );
      } else {
        throw 'Cannot get proper avatar model';
      }
    } else {
      throw 'Cannot get proper avatar model';
    }
  }

  static AvatarInterface getViewAvatar(String fileName, String url) {
    if (fileName == 'RedBook.png') {
      return StandardAvatarRed();
    } else if (fileName == 'GreenBook.png') {
      return StandardAvatarGreen();
    } else if (fileName == 'BlueBook.png') {
      return StandardAvatarBlue();
    } else {
      return CustomAvatar(avatarImgUrl: url);
    }
  }
}
