import 'package:app/interfaces/avatar_interface.dart';
import 'package:equatable/equatable.dart';

class StandardAvatarRed extends Equatable implements StandardAvatarInterface {
  @override
  String get imgAssetsPath => 'assets/images/RedBook.png';

  @override
  List<Object> get props => [];
}

class StandardAvatarGreen extends Equatable implements StandardAvatarInterface {
  @override
  String get imgAssetsPath => 'assets/images/GreenBook.png';

  @override
  List<Object> get props => [];
}

class StandardAvatarBlue extends Equatable implements StandardAvatarInterface {
  @override
  String get imgAssetsPath => 'assets/images/BlueBook.png';

  @override
  List<Object> get props => [];
}

class CustomAvatar extends Equatable implements CustomAvatarInterface {
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

  @override
  List<Object> get props => [
        _imgUrl ?? '',
        _imgFilePathFromDevice ?? '',
      ];
}
