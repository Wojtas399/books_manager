import '../entities/fire_user.dart';
import '../fire_references.dart';

class FireUserService {
  Future<void> setUserData({
    required String username,
    required String pathToAvatarInStorage,
  }) async {
    await FireReferences.loggedUserRefWithConverter.set(
      FireUser(
        username: username,
        avatarPath: pathToAvatarInStorage,
      ),
    );
  }
}
