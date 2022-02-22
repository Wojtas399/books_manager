abstract class AvatarInterface {}

abstract class StandardAvatarInterface implements AvatarInterface {
  String? get imgAssetsPath;
}

abstract class CustomAvatarInterface implements AvatarInterface {
  String? get imgUrl;

  String? get imgFilePathFromDevice;
}
