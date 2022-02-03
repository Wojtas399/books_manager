import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot>? subscribeUserData() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return _firestore.collection('Users').doc(user.uid).snapshots();
    }
    return null;
  }

  String? getEmail() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  Future<String> getAvatarUrl({required String avatarPath}) async {
    return await _storage.ref(avatarPath).getDownloadURL();
  }

  Future<String> changeAvatar({required String avatar}) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await _deleteCurrentAvatar(user);
        String newAvatarPath = await _addNewAvatar(avatar);
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .update({'avatarPath': newAvatarPath});
        return 'success';
      } catch (error) {
        throw error.toString();
      }
    } else {
      throw 'user does not exist';
    }
  }

  Future<String> changeUsername({required String newUsername}) async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .update({'userName': newUsername});
        return 'success';
      } else {
        throw 'User does not exist';
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<String> changeEmail({
    required String newEmail,
    required String password,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    final String? email = user != null ? user.email : null;
    if (user != null && email != null) {
      try {
        await _reauthenticate(user, email, password);
        await user.updateEmail(newEmail);
        return 'success';
      } catch (error) {
        throw error.toString();
      }
    } else {
      throw 'User does not exist';
    }
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    final String? email = user != null ? user.email : null;
    if (user != null && email != null) {
      try {
        await _reauthenticate(user, email, currentPassword);
        await user.updatePassword(newPassword);
        return 'success';
      } catch (error) {
        throw error.toString();
      }
    } else {
      throw 'User does not exist';
    }
  }

  Future<String> _deleteCurrentAvatar(User user) async {
    final currentUserDoc =
        await _firestore.collection('Users').doc(user.uid).get();
    if (currentUserDoc.exists) {
      final data = currentUserDoc.data();
      if (data != null) {
        String avatarPath = data['avatarPath'];
        if (avatarPath.split('/')[0] != 'avatars') {
          try {
            await _storage.ref(avatarPath).delete();
            return 'success';
          } catch (error) {
            throw error.toString();
          }
        } else {
          return 'success';
        }
      } else {
        throw 'data do not exist';
      }
    } else {
      throw 'user doc does not exist';
    }
  }

  Future<String> _addNewAvatar(String avatar) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        String avatarPath = '';
        List<String> imgFileArr = avatar.split('/');
        if (imgFileArr.length > 1) {
          avatarPath = user.uid + '/' + imgFileArr[imgFileArr.length - 1];
          File imgFile = File(avatar);
          await _storage.ref().child(avatarPath).putFile(imgFile);
        } else {
          avatarPath = 'avatars/' + avatar;
        }
        return avatarPath;
      } catch (error) {
        throw error.toString();
      }
    } else {
      throw 'user does not exist';
    }
  }

  Future _reauthenticate(User user, String email, String password) async {
    await user.reauthenticateWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
  }
}
