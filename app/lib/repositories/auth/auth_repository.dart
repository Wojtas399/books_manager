import 'package:app/backend/auth_service.dart';
import 'package:app/repositories/auth/auth_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    required String avatar,
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
  Stream<DocumentSnapshot>? subscribeUserData() {
    return _authService.subscribeUserData();
  }

  @override
  String? getEmail() {
    return _authService.getEmail();
  }

  @override
  Future<String> getAvatarUrl({required String avatarPath}) async {
    try {
      return await _authService.getAvatarUrl(avatarPath: avatarPath);
    } catch (error) {
      throw error;
    }
  }

  @override
  changeAvatar({required String avatar}) async {
    try {
      await _authService.changeAvatar(avatar: avatar);
    } catch (error) {
      throw error;
    }
  }

  @override
  changeUsername({required String newUsername}) async {
    try {
      await _authService.changeUsername(newUsername: newUsername);
    } catch (error) {
      throw error;
    }
  }

  @override
  changeEmail({
    required String newEmail,
    required String password,
  }) async {
    try {
      await _authService.changeEmail(newEmail: newEmail, password: password);
    } catch (error) {
      throw error;
    }
  }

  @override
  changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
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
