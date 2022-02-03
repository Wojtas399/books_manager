import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserInterface {
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
}
