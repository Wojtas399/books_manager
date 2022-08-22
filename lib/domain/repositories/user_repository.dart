import '../../database/firebase/fire_extensions.dart';
import '../../database/firebase/services/fire_avatar_service.dart';
import '../../database/firebase/services/fire_user_service.dart';
import '../../interfaces/user_interface.dart';
import '../../models/avatar.dart';

class UserRepository implements UserInterface {
  late final FireUserService _fireUserService;
  late final FireAvatarService _fireAvatarService;

  UserRepository({
    required FireUserService fireUserService,
    required FireAvatarService fireAvatarService,
  }) {
    _fireUserService = fireUserService;
    _fireAvatarService = fireAvatarService;
  }

  @override
  Future<void> setUserData({
    required String username,
    required Avatar avatar,
  }) async {
    String avatarPath = '';
    if (avatar is FileAvatar) {
      avatarPath = await _fireAvatarService.uploadLoggedUserAvatar(
        imageFile: avatar.file,
      );
    } else if (avatar is BasicAvatar) {
      avatarPath = avatar.type.toFirebaseString();
    }
    await _fireUserService.setUserData(
      username: username,
      pathToAvatarInStorage: avatarPath,
    );
  }
}
