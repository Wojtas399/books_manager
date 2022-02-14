import 'package:app/repositories/avatars/sign_up_backend_avatar_interface.dart';

class StandardAvatarRed implements SignUpBackendStandardAvatarInterface {
  @override
  String get imgPathInDb => 'avatars/RedBook.png';
}

class StandardAvatarGreen implements SignUpBackendStandardAvatarInterface {
  @override
  String get imgPathInDb => 'avatars/GreenBook.png';
}

class StandardAvatarBlue implements SignUpBackendStandardAvatarInterface {
  @override
  String get imgPathInDb => 'avatars/BlueBook.png';
}

class CustomAvatar implements SignUpBackendCustomAvatarInterface {
  late final String _filePath;

  CustomAvatar({required String imgFilePathFromDevice}) {
    _filePath = imgFilePathFromDevice;
  }

  @override
  String get imgFilePathFromDevice => _filePath;
}
