import 'package:app/interfaces/avatars/avatar_interface.dart';

class StandardAvatarRed implements StandardAvatarInterface {
  @override
  String get imgAssetsPath => 'assets/images/RedBook.png';
}

class StandardAvatarGreen implements StandardAvatarInterface {
  @override
  String get imgAssetsPath => 'assets/images/GreenBook.png';
}

class StandardAvatarBlue extends StandardAvatarInterface {
  @override
  String get imgAssetsPath => 'assets/images/BlueBook.png';
}

class CustomAvatar implements CustomAvatarInterface {
  late final String? _imgUrl;
  late final String? _imgFilePathFromDevice;

  CustomAvatar({String? avatarImgUrl, String? imgFilePathFromDevice}) {
    _imgUrl = avatarImgUrl;
    _imgFilePathFromDevice = imgFilePathFromDevice;
  }

  @override
  String? get imgUrl => _imgUrl;

  @override
  String? get imgFilePathFromDevice => _imgFilePathFromDevice;
}
