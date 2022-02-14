import 'package:app/backend/models/avatar_backend_model.dart';
import 'package:app/repositories/avatars/sign_up_backend_avatar_interface.dart';

class BackendAvatarProvider {
  static SignUpBackendAvatarInterface getStandardAvatarRed() {
    return StandardAvatarRed();
  }

  static SignUpBackendAvatarInterface getStandardAvatarGreen() {
    return StandardAvatarGreen();
  }

  static SignUpBackendAvatarInterface getStandardAvatarBlue() {
    return StandardAvatarBlue();
  }

  static SignUpBackendAvatarInterface getCustomAvatar({
    required String imgFilePathFromDevice,
  }) {
    return CustomAvatar(imgFilePathFromDevice: imgFilePathFromDevice);
  }
}
