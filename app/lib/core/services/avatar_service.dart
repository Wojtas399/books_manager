import 'package:app/models/avatar_model.dart';
import 'package:app/interfaces/avatar_interface.dart';

class AvatarService {
  static AvatarInterface getAvatarModel(String fileName, String url) {
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
