abstract class SignUpBackendAvatarInterface {}

abstract class SignUpBackendStandardAvatarInterface
    implements SignUpBackendAvatarInterface {
  String get imgPathInDb;
}

abstract class SignUpBackendCustomAvatarInterface
    implements SignUpBackendAvatarInterface {
  String get imgFilePathFromDevice;
}
