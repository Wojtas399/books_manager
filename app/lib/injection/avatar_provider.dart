import 'package:app/backend/models/avatar.dart';
import 'package:app/repositories/avatar_interface.dart';

class AvatarProvider {
  static AvatarInterface getAvatarDefaultRed() {
    return AvatarDefaultRed();
  }

  static AvatarInterface getAvatarDefaultGreen() {
    return AvatarDefaultGreen();
  }

  static AvatarInterface getAvatarDefaultBlue() {
    return AvatarDefaultBlue();
  }

  static AvatarInterface getAvatarCustom(String imgFilePath) {
    return AvatarCustom(avatarImgFilePath: imgFilePath);
  }
}
