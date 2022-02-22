import 'package:app/backend/services/auth_service.dart';
import 'package:app/backend/services/avatar_service.dart';
import 'package:app/interfaces/auth_interface.dart';
import 'package:app/interfaces/avatar_interface.dart';

class AuthRepository implements AuthInterface {
  late final AuthService _authService;
  late final AvatarService _avatarService;

  AuthRepository({
    required AuthService authService,
    required AvatarService avatarService,
  }) {
    _authService = authService;
    _avatarService = avatarService;
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
    required AvatarInterface avatar,
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
