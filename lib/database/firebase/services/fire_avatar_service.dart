import 'dart:io';

import '../fire_instances.dart';
import '../fire_logged_user_data.dart';

class FireAvatarService {
  Future<String> uploadLoggedUserAvatar({
    required File imageFile,
  }) async {
    final String avatarPath = '${FireLoggedUserData.id}/avatar.jpg';
    final avatarRef = FireInstances.storage.ref(avatarPath);
    await avatarRef.putFile(imageFile);
    return avatarPath;
  }
}
