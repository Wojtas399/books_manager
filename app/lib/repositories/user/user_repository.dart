import 'package:app/backend/services/user_service.dart';
import 'package:app/repositories/user/user_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends UserInterface {
  UserService _userService;

  UserRepository({required UserService userService})
      : _userService = userService;

  @override
  Stream<DocumentSnapshot>? subscribeUserData() {
    return _userService.subscribeUserData();
  }

  @override
  String? getEmail() {
    return _userService.getEmail();
  }

  @override
  Future<String> getAvatarUrl({required String avatarPath}) async {
    try {
      return await _userService.getAvatarUrl(avatarPath: avatarPath);
    } catch (error) {
      throw error;
    }
  }

  @override
  changeAvatar({required String avatar}) async {
    try {
      await _userService.changeAvatar(avatar: avatar);
    } catch (error) {
      throw error;
    }
  }

  @override
  changeUsername({required String newUsername}) async {
    try {
      await _userService.changeUsername(newUsername: newUsername);
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
      await _userService.changeEmail(newEmail: newEmail, password: password);
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
      await _userService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (error) {
      throw error;
    }
  }
}
