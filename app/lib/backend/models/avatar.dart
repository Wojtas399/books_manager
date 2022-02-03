import 'package:app/repositories/avatar_interface.dart';

class AvatarDefaultRed implements AvatarInterface {
  @override
  String getImgFilePath() {
    return 'avatars/RedBook.png';
  }
}

class AvatarDefaultGreen implements AvatarInterface {
  @override
  String getImgFilePath() {
    return 'avatars/GreenBook.png';
  }
}

class AvatarDefaultBlue implements AvatarInterface {
  @override
  String getImgFilePath() {
    return 'avatars/BlueBook.png';
  }
}

class AvatarCustom implements AvatarInterface {
  late final String _avatarImgFilePath;

  AvatarCustom({required String avatarImgFilePath}) {
    _avatarImgFilePath = avatarImgFilePath;
  }

  @override
  String getImgFilePath() {
    return _avatarImgFilePath;
  }
}
