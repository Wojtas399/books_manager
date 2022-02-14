import 'package:app/interfaces/avatars/sign_up_backend_avatar_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserInterface {
  Stream<DocumentSnapshot>? subscribeUserData();

  String? getEmail();

  Future<String> getAvatarUrl({required String avatarPath});

  changeAvatar({required SignUpBackendAvatarInterface avatar});

  changeUsername({required String newUsername});

  changeEmail({required String newEmail, required String password});

  changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
