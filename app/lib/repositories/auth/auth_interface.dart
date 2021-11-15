import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthInterface {
  signIn({required String email, required String password});

  signUp({
    required String username,
    required String email,
    required String password,
    required String avatar,
  });

  Stream<DocumentSnapshot>? subscribeUserData();

  String? getEmail();

  Future<String> getAvatarUrl({
    required String avatarPath,
  });

  changeAvatar({
    required String avatar,
  });

  changeUsername({
    required String newUsername,
  });

  changeEmail({
    required String newEmail,
    required String password,
  });

  changePassword({
    required String currentPassword,
    required String newPassword,
  });

  logOut();
}
