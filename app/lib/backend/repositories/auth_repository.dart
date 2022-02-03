import 'package:app/backend/services/auth_service.dart';
import 'package:app/repositories/auth_interface.dart';

import '../../repositories/avatar_interface.dart';

class AuthRepository implements AuthInterface {
  AuthService _authService;

  AuthRepository({required AuthService authService})
      : _authService = authService;

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
      await _authService.signUp(
        username: username,
        email: email,
        password: password,
        avatar: avatar,
      );
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
