import 'package:app/common/enum/avatar_type.dart';
import 'package:app/injection/avatar_provider.dart';
import 'package:app/models/http_result.model.dart';
import 'package:app/repositories/auth_interface.dart';
import 'package:app/repositories/avatar_interface.dart';

class AuthBloc {
  late AuthInterface _authInterface;

  AuthBloc({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Stream<HttpResult> signIn({
    required String email,
    required String password,
  }) async* {
    try {
      await _authInterface.signIn(email: email, password: password);
      yield HttpSuccess();
    } catch (error) {
      yield HttpFailure(message: error.toString());
    }
  }

  Stream<HttpResult> signUp({
    required String username,
    required String email,
    required String password,
    required AvatarType avatarType,
    String? customAvatarPath,
  }) async* {
    try {
      await _authInterface.signUp(
        username: username,
        email: email,
        password: password,
        avatar: _getAvatar(avatarType, customAvatarPath ?? ''),
      );
      yield HttpSuccess();
    } catch (error) {
      yield HttpFailure(message: error.toString());
    }
  }

  signOut() async {
    await _authInterface.logOut();
  }

  AvatarInterface _getAvatar(AvatarType type, String customAvatarFilePath) {
    switch (type) {
      case AvatarType.red:
        return AvatarProvider.getAvatarDefaultRed();
      case AvatarType.green:
        return AvatarProvider.getAvatarDefaultGreen();
      case AvatarType.blue:
        return AvatarProvider.getAvatarDefaultBlue();
      case AvatarType.custom:
        return AvatarProvider.getAvatarCustom(customAvatarFilePath);
    }
  }
}
