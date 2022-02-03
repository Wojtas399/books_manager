import 'dart:io';
import 'package:app/backend/models/avatar.dart';
import 'package:app/repositories/avatar_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Signed in';
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    }
  }

  Future<String> signUp({
    required String username,
    required String email,
    required String password,
    required AvatarInterface avatar,
  }) async {
    try {
      UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? userId = credential.user?.uid;
      if (userId == null) {
        throw 'Something went wrong with user registration.';
      }
      String avatarPath = avatar.getImgFilePath();
      if (avatar is AvatarCustom) {
        avatarPath = await _putAvatarFileToDb(avatarPath);
      }
      await _firestore
          .collection('Users')
          .doc(userId)
          .set({'avatarPath': avatarPath, 'userName': username});
      return 'success';
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    }
  }

  Future<String> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return 'success';
    } on FirebaseAuthException catch (error) {
      throw error.message.toString();
    }
  }

  Future<String> _putAvatarFileToDb(String filePath) async {
    String? filePathInDb = _generateCustomAvatarFilePathInDb(filePath);
    if (filePathInDb != null) {
      File file = File(filePath);
      await _storage.ref().child(filePathInDb).putFile(file);
      return filePathInDb;
    } else {
      throw 'Cannot generate path for custom avatar';
    }
  }

  String? _generateCustomAvatarFilePathInDb(String filePath) {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      List<String> filePathParties = filePath.split('/');
      return '${user.uid}/${filePathParties[filePathParties.length - 1]}';
    }
  }
}
