import 'package:app/backend/services/auth_service.dart';
import 'package:app/backend/services/avatar_service.dart';
import 'package:app/repositories/auth_interface.dart';
import 'package:app/repositories/avatars/sign_up_backend_avatar_interface.dart';

class AuthRepository implements AuthInterface {
  final AvatarService _avatarService = new AvatarService();
  late final AuthService _authService;

  AuthRepository({required AuthService authService}) {
    _authService = authService;
  }

  @override
  signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _authService.signIn(email: email, password: password);
    } catch (error) {
      throw error;
    }
  }

  @override
  signUp({
    required String username,
    required String email,
    required String password,
    required SignUpBackendAvatarInterface avatar,
  }) async {
    try {
      AvatarType? avatarType = _avatarService.getAvatarType(avatar);
      if (avatarType != null) {
        await _authService.signUp(
          username: username,
          email: email,
          password: password,
          avatarType: avatarType,
          avatarImgFilePath: _avatarService.getImgFilePath(avatar),
        );
      } else {
        throw 'The problem with avatar type conversion has occurred';
      }
    } catch (error) {
      throw error;
    }
  }

  @override
  logOut() async {
    try {
      await _authService.logOut();
    } catch (error) {
      throw error;
    }
  }
}
